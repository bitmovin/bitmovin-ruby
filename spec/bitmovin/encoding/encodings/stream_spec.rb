require "spec_helper"

describe Bitmovin::Encoding::Encodings::Stream do
  let(:stream_json) {
    {
      name: "Production-ID-678",
      description: "Project ID: 567",
      inputStreams: [
        {
          inputId: "47c3e8a3-ab76-46f5-8b07-cd2e2b0c3728",
          inputPath: "/videos/movie1.mp4",
          selectionMode: "AUTO"
        }
      ],
      codecConfigId: "d09c1a8a-4c56-4392-94d8-81712118aae0",
      outputs: [
        {
          outputId: "55354be6-0237-42bb-ae85-a2d4ef1ed19e",
          outputPath: "/encodings/movies/movie-1/video_720/",
          acl: [
            {
              permission: "PUBLIC_READ"
            }
          ]
        }
      ],
      id: "a6336204-c929-4a61-b7a0-2cd6665114e9",
      createdAt: "2016-06-25T20:09:23.69Z",
      modifiedAt: "2016-06-25T20:09:23.69Z"
    }
  }

  let(:stream) { Bitmovin::Encoding::Encodings::Stream.new('encoding-id', stream_json) }
  subject { stream }
  it { should respond_to(:id) }
  it { should respond_to(:encoding_id) }
  it { should respond_to(:name) }
  it { should respond_to(:description) }
  it { should respond_to(:created_at) }
  it { should respond_to(:modified_at) }
  it { should respond_to(:codec_config_id) }

  it { should respond_to(:save!) }
  it { should respond_to(:delete!) }

  
  it { should respond_to(:input_streams) }
  it { should respond_to(:outputs) }
  it { should respond_to(:outputs) }
  it { should respond_to(:codec_configuration) }
  it { should respond_to(:codec_configuration=).with(1).argument }

  describe "outputs" do
    subject { stream.outputs }
    it "should return an Array" do
      expect(subject).to be_a(Array)
    end
    it "should return an Array of StreamOutput" do
      expect(subject.first).to be_a(Bitmovin::Encoding::Encodings::StreamOutput)
    end
    it "should return an Array of StreamOutput with correct encoding_id" do
      expect(subject.first.encoding_id).to eq(stream.encoding_id)
    end
    it "should return an Array of StreamOutput with correct stream_id" do
      expect(subject.first.stream_id).to eq(stream.id)
    end
  end
end
