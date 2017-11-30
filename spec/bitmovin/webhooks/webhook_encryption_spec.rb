require "spec_helper"

describe Bitmovin::Webhooks::WebhookEncryption do
  let(:json) {
    {
        type: "AES",
        key: "secretKey"
    }
  }
  subject { Bitmovin::Webhooks::WebhookEncryption.new(json) }

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
    it "should be serialized correctly to json" do
      expect(subject.to_json(nil)).to eq("{\"type\":\"AES\",\"key\":\"secretKey\"}")
    end
  end
end
