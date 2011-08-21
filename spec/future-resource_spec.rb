require 'future-resource'

describe FutureResource do
  before(:all) do
    @fr = FutureResource.new
  end

  it "should create a FutureResource" do
    @fr.should be_instance_of FutureResource 
  end

  it "should not be ready yet" do
    @fr.should_not be_set_yet
  end

  it "should set resource" do
    @fr.resource = :foo
  end

  it "should be ready" do
    @fr.should be_set_yet
  end

  it "should raise ResourceAlreadySetException when setting value that is already set" do
    expect {
      @fr.resource = :bar
    }.to raise_error FutureResource::ResourceAlreadySetException
  end

  it "should return the resource" do
    @fr.resource.should === :foo 
  end


  it "should receive the resource value from another thread" do
    fr = FutureResource.new
    Thread.new do
      sleep 1
      fr.resource = :foo
    end
    fr.resource.should === :foo
  end

end
