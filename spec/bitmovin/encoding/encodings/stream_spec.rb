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
      createQualityMetaData: true,
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
  it { should respond_to(:codec_configuration) }
  it { should respond_to(:create_quality_meta_data) }

  it { should respond_to(:save!) }
  it { should respond_to(:delete!) }

  
  it { should respond_to(:input_streams) }
  it { should respond_to(:build_input_stream).with(0..1).argument }
  it { should respond_to(:outputs) }
  it { should respond_to(:outputs) }
  it { should respond_to(:codec_configuration) }
  it { should respond_to(:codec_configuration=).with(1).argument }
  it { should respond_to(:build_output).with(0..1).argument }

  describe "initialize" do
    it { is_expected.to have_attributes(create_quality_meta_data: true) }
    it { is_expected.to have_attributes(id: "a6336204-c929-4a61-b7a0-2cd6665114e9") }
    it { is_expected.to have_attributes(codec_configuration: "d09c1a8a-4c56-4392-94d8-81712118aae0") }
    it "should initialze outputs" do
      expect(subject).to have_exactly(1).outputs
      expect(subject.outputs).to include(have_attributes(output_id: "55354be6-0237-42bb-ae85-a2d4ef1ed19e")) 
    end

    it "should initialize input_streams" do
      expect(subject).to have_exactly(1).input_streams
      expect(subject.input_streams).to include(have_attributes(input_id: "47c3e8a3-ab76-46f5-8b07-cd2e2b0c3728")) 
    end
  end

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

  describe "input_streams" do
    subject { stream.input_streams }

    it "should return an Array" do
      expect(subject).to be_a(Array)
    end

    it "should return an array of StreamInput" do
      expect(subject.first).to be_a(Bitmovin::Encoding::Encodings::StreamInput)
    end

    it "should return an Array of StreamInput with correct encoding_id" do
      expect(subject.first.encoding_id).to eq(stream.encoding_id)
    end

    it "should return an Array of StreamInput with correct stream_id" do
      expect(subject.first.stream_id).to eq(stream.id)
    end
  end

  describe "build_output" do
    subject { stream.build_output(output_id: 'output') }
    it "should return a StreamOutput" do
      expect(subject).to be_a(Bitmovin::Encoding::Encodings::StreamOutput)
    end

    it "should return a StreamOutput with correct encoding_id" do
      expect(subject.encoding_id).to eq(stream.encoding_id)
    end
    
    it "should return a StreamOutput with correct stream_id" do
      expect(subject.stream_id).to eq(stream.id)
    end

    it "should return a StreamOutput initialized from parameter hash" do
      expect(subject.output_id).to eq('output')
    end

    it "should be automatically be added to outputs array of Stream" do
      expect(stream.outputs).to include(subject)
    end

    it "should be a reference" do
      subject.output_path = "test"
      expect(stream.outputs).to include(have_attributes(output_path: "test"))
    end
  end

  describe "build_input_stream" do
    subject { stream.build_input_stream(input_id: 'input', input_path: '/var/www.mp4') }
    it "should return a StreamInput" do
      expect(subject).to be_a(Bitmovin::Encoding::Encodings::StreamInput)
    end

    it "should return a StreamInput with correct encoding_id" do
      expect(subject.encoding_id).to eq(stream.encoding_id)
    end
    
    it "should return a StreamInput with correct stream_id" do
      expect(subject.stream_id).to eq(stream.id)
    end

    it "should return a StreamInput initialized from parameter hash" do
      expect(subject.input_id).to eq('input')
    end

    it "should be automatically be added to outputs array of Stream" do
      expect(stream.input_streams).to include(subject)
    end

    it "should be a reference" do
      subject.input_path = "test"
      expect(stream.input_streams).to include(have_attributes(input_path: "test"))
    end
  end

  describe "codec_configuration=" do
    subject { stream }
    
    it "should accept a codec configuration as parameter" do
      config = Bitmovin::Encoding::CodecConfigurations::H264Configuration.new(id: 'codec-config')
      expect { subject.codec_configuration = config }.to change{ subject.codec_configuration }.to('codec-config')
    end
    it "should accept a codec configuration id as parameter" do
      expect { subject.codec_configuration = 'codec-id' }.to change{ subject.codec_configuration }.to('codec-id')
    end
  end
end
