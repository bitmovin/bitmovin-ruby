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

  it { should respond_to(:conditions) }

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

    context "without hash" do
      subject  { Bitmovin::Encoding::Encodings::Stream.new('encoding-id') }
      it { is_expected.to have(0).input_streams }
      it { is_expected.to have(0).outputs }
    end
  end

  describe "outputs" do
    subject { stream.outputs }
    it "should return an Array" do
      expect(subject).to be_a(Array)
    end
    it "should return an Array of StreamOutput" do
      expect(subject.first).to be_a(Bitmovin::Encoding::StreamOutput)
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
      expect(subject).to be_a(Bitmovin::Encoding::StreamOutput)
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

  it { should respond_to(:valid?) }
  it { should respond_to(:invalid?) }
  it { should respond_to(:errors) }

  describe "validation" do
    context "without input_streams" do
      subject { Bitmovin::Encoding::Encodings::Stream.new('encoding-id') }
      it "should return false" do
        expect(subject).to be_invalid
      end

      it "should add error to errors" do
        subject.valid?
        expect(subject.errors).to include("Stream needs at least one input_stream")
      end
    end
    context "with one invalid input_stream" do
      subject do
        stream.input_streams.clear
        stream.build_input_stream
        stream
      end

      it "should return false" do
        expect(subject).to be_invalid
      end

      it "should call valid? on input_stream" do
        expect(subject.input_streams.first).to receive(:valid?)
        subject.valid?
      end

      it "should add error from input stream to errors" do
        allow(subject.input_streams.first).to receive(:valid?).and_return(false)
        allow(subject.input_streams.first).to receive(:errors).and_return(["invalid"])
        expect(subject).to be_invalid
        expect(subject).to have(1).errors
        expect(subject.errors).to eq(["invalid"])
      end
    end

    context "with valid values" do
      subject { stream }
      it { is_expected.to be_valid }
    end

    context "without a codec configuration" do
      subject do
        stream.codec_configuration = ""
        stream
      end

      it "should return false" do
        expect(subject).to be_invalid
      end

      it "should add to errors" do
        subject.valid?
        expect(subject).to have(1).errors
      end
    end

    context "with invalid outputs" do
      subject { stream }
      
      it "should allow empty outputs" do
        stream.outputs.clear
        expect(stream).to be_valid
      end

      it "should not allow invalid outputs" do
        allow(stream.outputs.first).to receive(:valid?).and_return(false)
        allow(stream.outputs.first).to receive(:errors).and_return(["invalid"])
        expect(stream).to be_invalid
        expect(subject).to have(1).errors
        expect(subject.errors).to eq(["invalid"])
      end

      it "should validate outputs" do
        expect(subject.outputs.first).to receive(:valid?)
        subject.valid?
      end
    end
  end

  describe "valid?" do
    subject { Bitmovin::Encoding::Encodings::Stream.new('encoding-id') }
    it "should return true if @errors is not empty" do
      allow(subject).to receive(:@errors).and_return(["test"])
      expect(subject.valid?).to be_falsy
    end
  end

  describe "invalid?" do
    it "should call valid?" do
      expect(subject).to receive(:valid?).and_return(false)
      subject.invalid?
    end
    it "should invert valid?" do
      allow(subject).to receive(:valid?).and_return(false)
      expect(subject).to be_invalid
    end
  end

  describe "save" do
    it "should call valid?" do
      expect(subject).to receive(:valid?)
      subject.save!
    end
    let(:body) do
      stream_json.delete(:id)
      stream_json.delete(:modifiedAt)
      stream_json.delete(:createdAt)
      expected_body = stream_json
      expected_body
    end
    before(:each) do
      stub_request(:post, /.*#{"/v1/encoding/encodings/#{stream.encoding_id}/streams"}/)
        .with(body: body)
        .to_return(body: response_envelope({id: 'test'}).to_json)
    end

    it "should not send conditions if not set" do
      body.delete(:conditions)
      stub_request(:post, /.*#{"/v1/encoding/encodings/#{stream.encoding_id}/streams"}/)
        .with(body: body)
        .to_return(body: response_envelope({id: 'test'}).to_json)
      subject.id = nil
      expect(subject.save!).to have_requested(:post, /.*#{"/v1/encoding/encodings/#{stream.encoding_id}/streams"}/).with(body: body)
    end
    it "should send conditions if a value is set" do
      body["conditions"] = { some: "condition" }
      stub_request(:post, /.*#{"/v1/encoding/encodings/#{stream.encoding_id}/streams"}/)
        .with(body: body)
        .to_return(body: response_envelope({id: 'test'}).to_json)
      subject.id = nil
      subject.conditions = { some: "condition" }
      expect(subject.save!).to have_requested(:post, /.*#{"/v1/encoding/encodings/#{stream.encoding_id}/streams"}/).with(body: body)
    end

    it "should call POST /v1/encoding/encodings/<encoding-id>/streams with correct body" do
      subject.id = nil
      expect(subject.save!).to have_requested(:post, /.*#{"/v1/encoding/encodings/#{stream.encoding_id}/streams"}/).with(body: body)
    end

    it "should call POST /v1/encoding/encodings/<encoding-id>/streams" do
      subject.id = nil
      expect(subject.save!).to have_requested(:post, /.*#{"/v1/encoding/encodings/#{stream.encoding_id}/streams"}/)
    end

  end
  describe "delete!" do
    before(:each) do
      stub_request(:delete, /.*#{"/v1/encoding/encodings/#{stream.encoding_id}/streams/#{stream.id}"}/)
    end
    it "should call DELETE /v1/encoding/encodings/<encoding-id>/streams/<stream-id>" do
      expect(subject.delete!).to have_requested(:delete, /.*#{"/v1/encoding/encodings/#{stream.encoding_id}/streams/#{stream.id}"}/)
    end
  end
end
