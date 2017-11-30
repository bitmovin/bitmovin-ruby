require "spec_helper"

describe Bitmovin::Encoding::StreamOutput do
  let(:json) {
    {
        type: "HMAC",
        key: "secretKey"
    }
  }
  subject { Bitmovin::Webhooks::WebhookSignature.new(json) }

  it { should respond_to(:type) }
  it { should respond_to(:key) }
  it { should respond_to(:valid?) }
  it { should respond_to(:invalid?) }

  describe "validation" do
    it "without key should be invalid" do
      subject.key = nil
      expect(subject).to be_invalid
    end
    it "without type should be invalid" do
      subject.type = ""
      expect(subject).to be_invalid
    end
    it "should be valid if all is set" do
      expect(subject).to be_valid
    end
  end
end
