require 'future-resource'

describe FutureResource do
  it "should create a FutureResource" do
    fr = FutureResource.new
    fr.should be_instance_of FutureResource 
  end

  it "should not be ready yet" do
    subject.should_not be_set_yet
  end

  it "should set resource" do
    subject.resource = :foo
  end

  it "should be ready" do
    subject.resource = :foo
    subject.should be_set_yet
  end

  it "should raise ResourceAlreadySetException when setting value that is already set" do
    subject.resource = :foo
    expect {
      subject.resource = :bar
    }.to raise_error FutureResource::ResourceAlreadySetException
  end

  it "should return the resource" do
    subject.resource = :foo
    subject.resource.should === :foo 
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
