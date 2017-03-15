require "spec_helper"

describe Bitmovin::Encoding::Encodings do
  subject { Bitmovin::Encoding::Encodings }
  it { should respond_to(:list).with(0..2).arguments }

  describe "list" do
    subject { Bitmovin::Encoding::Encodings.list }
    it "should forward call to EncodingTask#list" do
      expect(Bitmovin::Encoding::Encodings::EncodingTask).to receive(:list)
      subject
    end
  end
end
