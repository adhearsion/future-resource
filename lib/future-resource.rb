require "thread"
require "monitor"
require "timeout"

##
# future-resource allows you to wait on a final value being set for a placeholder, which may occur asynchronously.
#
# @author Ben Langfeld
# @author Jay Phillips
#
# @example false printed first, followed by a delay before :foo is printed
#   fr = FutureResource.new
#
#   Thread.new do
#     sleep 10
#     fr.resource = :foo
#   end
#
#   p fr.set_yet?
#   p fr.resource
#
class FutureResource
  ##
  # Create a new FutureResource.
  #
  def initialize
    @resource_lock          = Monitor.new
    @resource_value_blocker = @resource_lock.new_cond
    @terminated             = false
  end
  
  ##
  # Checks if the value of the resource placeholder has been set yet.
  #
  # @return [Boolean]
  #
  def set_yet?
    !!@resource_lock.synchronize { defined? @resource }
  end

  ##
  # Checks if the attempt to read the resource has been terminated.
  #
  # @return [Boolean]
  #
  def terminated?
    !!@resource_lock.synchronize { @terminated }
  end

  ##
  # Returns the value of a specific resource, optionally waiting for `timeout` seconds before
  # raising a Timeout::Error exception, or raising a FutureResource::Terminated exception if
  # the attempt to read the resource is terminated early by another thread.  When called on
  # an unset resource without a timeout, raises a deadlock.
  #
  # @param [Integer] timeout number of seconds to wait for the resource to become ready
  #
  # @raise [Timeout::Error] if timeout expires and resource is not ready
  # @raise [FutureResource::Terminated] if the attempt to read the resource is terminated by another thread
  #
  # @return [Object]
  #
  def resource(timeout = nil)
    Timeout::timeout timeout do
      @resource_lock.synchronize do
        @resource_value_blocker.wait unless set_yet? or terminated?
        raise Terminated if terminated?
        @resource
      end
    end
  end
  
  ##
  # Sets the value for the resource, making it available for all waiting and following reads.
  # Resource values can only be set once.  Calling this method on a terminated resource is
  # ineffective.
  #
  # @param [Object] resource any value to be set for the resource
  #
  # @raise [FutureResource::ResourceAlreadySet] if resource is already set
  #
  def resource=(resource)
    set_or_terminate do
      @resource = resource
    end
  end

  ##
  # Terminates the attempt to read the resource early, causing those waiting and any
  # following reads to raise a FutureResource::Terminated exception. Subsequently calling
  # this method again is ineffective.
  #
  # @raise [FutureResource::ResourceAlreadySet] if resource is already set
  #
  def terminate
    set_or_terminate do
      @terminated = true
    end
  end

  ##
  # Raised when the program tries to set a value for the resource that is already set.
  #
  class ResourceAlreadySetException < StandardError
    def initialize
      super "Cannot set this resource twice!"
    end
  end

  ##
  # Raised when the attempt to read the resource is terminated early.
  #
  class Terminated < StandardError
    def initialize
      super "Resource read attempt terminated"
    end
  end

  private

  def set_or_terminate
    @resource_lock.synchronize do
      return if terminated?
      raise ResourceAlreadySetException if set_yet?
      yield
      @resource_value_blocker.broadcast
      @resource_value_blocker = nil # Don't really need it anymore.
    end
  end
end
