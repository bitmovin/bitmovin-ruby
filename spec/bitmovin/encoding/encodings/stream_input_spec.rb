require "spec_helper"

describe Bitmovin::Encoding::Encodings::StreamInput do
  let(:json) {
    {
      inputId: "47c3e8a3-ab76-46f5-8b07-cd2e2b0c3728",
      inputPath: "/videos/movie1.mp4",
      selectionMode: "AUTO"
    }
  }
  subject { Bitmovin::Encoding::Encodings::StreamInput.new('encoding', nil, json) }

  it { should respond_to(:input_id) }
  it { should respond_to(:input_path) }
  it { should respond_to(:selection_mode) }
  it { should respond_to(:valid?) }
  it { should respond_to(:invalid?) }

  describe "validation" do
    it "without input_id should be invalid" do
      subject.input_id = nil
      expect(subject).to be_invalid
    end
    it "without input_path should be invalid" do
      subject.input_path = ""
      expect(subject).to be_invalid
    end
    it "without selection_mode should be invalid" do
      subject.selection_mode = ""
      expect(subject).to be_invalid
    end
    it "without position and selection_mode not auto should be invalid" do
      subject.selection_mode = "POSITION_ABSOLUTE"
      subject.position = ""
      expect(subject).to be_invalid
    end
    it "should be valid if all is set" do
      expect(subject).to be_valid
    end
  end
end
