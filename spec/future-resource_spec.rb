require 'future-resource'

describe FutureResource do
  it { should be_instance_of FutureResource }

  it { should_not be_set_yet }

  it "should set resource" do
    subject.resource = :foo
  end

  describe "with a resource set" do
    before { subject.resource = :foo }

    it { should be_set_yet }

    its(:resource) { should === :foo }

    it "should raise ResourceAlreadySetException when setting value that is already set" do
      expect {
        subject.resource = :bar
      }.to raise_error FutureResource::ResourceAlreadySetException
    end
  end

  it "should receive the resource value from another thread" do
    Thread.new do
      sleep 1
      subject.resource = :foo
    end
    subject.resource.should === :foo
  end
end
