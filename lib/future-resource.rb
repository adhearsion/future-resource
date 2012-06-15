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
  # Returns the value of a specific resource, optionally waiting for `timeout` seconds before raising a Timeout::Error exception.
  # When called on a not set resource without a timeout, raises a deadlock.
  #
  # @param [Integer] timeout number of seconds to wait for the resource to become ready
  #
  # @raise [Timeout::Error] if timeout expires and resource is not ready
  #
  # @return [Object]
  #
  def resource(timeout = nil)
    Timeout::timeout timeout do
      @resource_lock.synchronize do
        @resource_value_blocker.wait unless defined? @resource
        @resource
      end
    end
  end
  
  ##
  # Sets the value for the resource, making it available for all waiting and following reads.
  # Resource values can only be set once.
  #
  # @param [Object] resource any value to be set for the resource
  #
  # @raise [FutureResource::ResourceAlreadySet] if resource is already set
  def resource=(resource)
    @resource_lock.synchronize do
      raise ResourceAlreadySetException if defined? @resource
      @resource = resource
      @resource_value_blocker.broadcast
      @resource_value_blocker = nil # Don't really need it anymore.
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
end
