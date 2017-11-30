require "spec_helper"

describe Bitmovin::Encoding::StreamOutput do
  let(:json) {
    {
      outputId: "55354be6-0237-42bb-ae85-a2d4ef1ed19e",
      outputPath: "/encodings/movies/movie-1/video_720/",
      acl: [
        {
          permission: "PUBLIC_READ"
        }
      ]
    }
  }
  subject { Bitmovin::Encoding::StreamOutput.new(json) }

  it { should respond_to(:acl) }
  it { should respond_to(:valid?) }
  it { should respond_to(:invalid?) }

  describe "validation" do
    it "without output_id should be invalid" do
      subject.output_id = nil
      expect(subject).to be_invalid
    end
    it "without output_path should be invalid" do
      subject.output_path = ""
      expect(subject).to be_invalid
    end
    it "without acl should be valid" do
      subject.acl.clear
      expect(subject).to be_valid
    end
    it "should be valid if all is set" do
      expect(subject).to be_valid
    end
    it "should be serialized correctly to json" do
      expect(subject.to_json(nil)).to eq("{\"outputId\":\"55354be6-0237-42bb-ae85-a2d4ef1ed19e\",\"outputPath\":\"/encodings/movies/movie-1/video_720/\",\"acl\":[{\"permission\":\"PUBLIC_READ\"}]}")
    end
  end
end
