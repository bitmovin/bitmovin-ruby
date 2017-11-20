require "spec_helper"

describe Bitmovin::Encoding::Encodings::Muxings::TsMuxing do
  let(:muxing_json) {
    {
      name: "Production-ID-678",
      description: "Project ID: 567",
      streams: [
        {
          streamId: "f3177c2e-0000-4ba6-bd20-1dee353d8a72"
        }
      ],
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
      segmentLength: 4,
      segmentNaming: "seg_%number%.m4s",
      id: "5d8fb60a-8422-4d95-8157-b625413036de",
      createdAt: "2016-06-25T20:09:23.69Z",
      modifiedAt: "2016-06-25T20:09:23.69Z"
    }
  }
  let(:muxing) { Bitmovin::Encoding::Encodings::Muxings::TsMuxing.new('encoding-id', muxing_json) }
  subject { muxing }

  it { should respond_to(:id) }
  it { should respond_to(:name) }
  it { should respond_to(:description) }
  it { should respond_to(:segment_length) }
  it { should respond_to(:segment_naming) }
  it { should respond_to(:streams) }
  it { should respond_to(:outputs) }
  it { should respond_to(:drms) }

  it { should respond_to(:build_output).with(0..1).argument }

  describe "drms" do
    subject { muxing.drms }
    it { should respond_to(:aes) }
  end

  describe "outputs" do
    it "should be Array" do
      expect(subject.outputs).to be_a(Array)
    end

    it "should be Array of StreamOutput" do
      expect(subject.outputs.first).to be_a(Bitmovin::Encoding::StreamOutput)
    end

    it "should correctly populate StreamOutput" do
      expect(subject.outputs.first.output_path).to eq("/encodings/movies/movie-1/video_720/")
      expect(subject.outputs.first.output_id).to eq("55354be6-0237-42bb-ae85-a2d4ef1ed19e")
    end
  end

  describe "streams" do
    subject { muxing.streams }
    it "should be array" do
      expect(subject).to be_a(Array)
    end
    it "should be array of strings" do
      expect(subject.first).to be_a(String)
    end
    it "should have correct length" do
      expect(subject.size).to eq(1)
    end

    it "should correctly translate stream_id" do
      expect(subject.first).to eq("f3177c2e-0000-4ba6-bd20-1dee353d8a72")
    end

  end

  describe "collect_attributes" do
    subject { muxing.send(:collect_attributes) }
    it "should correctly collect outputs" do
      expect(subject["outputs"]).to be_a(Array)
      expect(subject["outputs"].first).to be_a(Hash)
      expect(subject["outputs"].first["outputId"]).to eq("55354be6-0237-42bb-ae85-a2d4ef1ed19e")
      expect(subject["outputs"].first["outputPath"]).to eq("/encodings/movies/movie-1/video_720/")
    end

    it "should correctly collect streams" do
      expect(subject["streams"]).to be_a(Array)
      expect(subject["streams"].first).to eq({"streamId" => "f3177c2e-0000-4ba6-bd20-1dee353d8a72"})
    end
  end

  describe "build_output" do
    subject { muxing.build_output(output_id: 'output') }
    it "should return a StreamOutput" do
      expect(subject).to be_a(Bitmovin::Encoding::StreamOutput)
    end

    it "should return a StreamOutput initialized from parameter hash" do
      expect(subject.output_id).to eq('output')
    end

    it "should be automatically be added to outputs array of muxing" do
      expect(muxing.outputs).to include(subject)
    end

    it "should be a reference" do
      subject.output_path = "test"
      expect(muxing.outputs).to include(have_attributes(output_path: "test"))
    end
  end
end
