require "spec_helper"

describe Bitmovin::Encoding::Encodings::StreamList do
  let(:stream_list) { Bitmovin::Encoding::Encodings::StreamList.new('encoding-id') }
  subject { stream_list }

  it { should respond_to(:list) }
  it { should respond_to(:find).with(1).argument }
  it { should respond_to(:add).with(1).argument }
  it { should respond_to(:build) }

  let(:stream) {
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

  describe "list" do
    subject { stream_list.list }
    before(:each) do
      stub_request(:get, /.*#{"/v1/encoding/encodings/encoding-id/streams"}.*/)
        .to_return(body: response_envelope(items: [stream]).to_json)
    end

    it "should call GET /v1/encoding/encodings/<encoding-id>/streams" do
      expect(subject).to have_requested(:get, /.*#{"/v1/encoding/encodings/encoding-id/streams"}.*/)
    end

    it "should return Array" do
      expect(subject).to be_a(Array)
    end
    it "should return Array of Streams" do
      expect(subject.first).to be_a(Bitmovin::Encoding::Encodings::Stream)
    end
    it "should return Array of Streams with correct encoding_id" do
      expect(subject.first.encoding_id).to eq(stream_list.encoding_id)
    end
    it "should return Array of Streams with correct stream id" do
      expect(subject.first.id).to eq(stream[:id])
    end
  end

  describe "build" do
    subject { stream_list.build }
    it "should return stream" do
      expect(subject).to be_a(Bitmovin::Encoding::Encodings::Stream)
    end
    it "should create stream with correct encoding_id" do
      expect(subject.encoding_id).to eq(stream_list.encoding_id)
    end
    it "should accept hash arguments" do
      expect(stream_list).to respond_to(:build).with(0..1).arguments
    end
    it "should pass hash arguments to Stream.new" do
      args = { foo: :bar }
      expect(Bitmovin::Encoding::Encodings::Stream).to receive(:new).with(stream_list.encoding_id, args)

      stream_list.build(args)
    end
  end

  describe "find" do
    subject { stream_list.find('stream-id') }

    before(:each) do
      stub_request(:get, /.*#{"/v1/encoding/encodings/encoding-id/streams/stream-id"}.*/)
        .to_return(body: response_envelope(stream).to_json)
    end

    it "should return a Stream" do
      expect(subject).to be_a(Bitmovin::Encoding::Encodings::Stream)
    end

    it "should call GET /v1/encoding/encodings/<encoding-id>/streams/<stream-id>" do
      expect(subject).to have_requested(:get, /.*#{"/v1/encoding/encodings/encoding-id/streams/stream-id"}.*/)
    end
  end

  describe "add" do
    subject { stream_list.add('test') }
    it "should raise not implemented error" do
      expect { subject }.to raise_error("Not implemented yet. Please use #build and Stream#save! for the time being")
    end
  end
end
