require 'future-resource'

describe FutureResource do
  it { should be_instance_of FutureResource }

  it { should_not be_set_yet }
  it { should_not be_terminated }

  it "should set resource" do
    subject.resource = :foo
  end

  it "should be terminateable" do
    subject.terminate
  end

  describe "with a resource set" do
    before { subject.resource = :foo }

    it { should be_set_yet }
    it { should_not be_terminated }

    its(:resource) { should === :foo }

    it "should raise ResourceAlreadySetException when setting value that is already set" do
      expect {
        subject.resource = :bar
      }.to raise_error FutureResource::ResourceAlreadySetException
    end

    it "should raise ResourceAlreadySetException when terminating" do
      expect {
        subject.terminate
      }.to raise_error FutureResource::ResourceAlreadySetException
    end
  end

  describe "that is terminated" do
    before { subject.terminate }

    it { should_not be_set_yet }
    it { should be_terminated }

    it "should raise a Terminated exception when getting the resource" do
      expect {
        subject.resource
      }.to raise_error FutureResource::Terminated
    end

    it "should ignore any attempt to set the resource" do
      subject.resource = :bar

      expect {
        subject.resource
      }.to raise_error FutureResource::Terminated
    end

    it "should ignore any attempt to terminate again" do
      subject.terminate
    end
  end

  it "should receive the resource value from another thread" do
    Thread.new do
      sleep 1
      subject.resource = :foo
    end
    subject.resource.should === :foo
  end

  it "should allow an alternative condition to be provided" do
    resource = described_class.new(ConditionVariable.new)
    Thread.new do
      sleep 1
      subject.resource = :foo
    end
    subject.resource.should === :foo
  end
end
