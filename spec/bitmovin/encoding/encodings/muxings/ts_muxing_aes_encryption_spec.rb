require "spec_helper"

describe Bitmovin::Encoding::Encodings::Muxings::Drms::TsMuxingAesEncryption do
	let(:muxing_json) {
		{
			"name": "Production-ID-678",
      "id": "cb90b80c-8867-4e3b-8479-174aa2843f62",
			"description": "Project ID: 567",
			"outputs": [
				{
					"outputId": "55354be6-0237-42bb-ae85-a2d4ef1ed19e",
					"outputPath": "/encodings/movies/movie-1/video_720/",
					"acl": [
						{
							"permission": "PUBLIC_READ"
						}
					]
				}
			],
			"method": "SAMPLE_AES",
			"key": "cab5b529ae28d5cc5e3e7bc3fd4a544d",
			"iv": "08eecef4b026deec395234d94218273d",
			"keyFileUri": "path/to/keyfile.key"
		}
  }
  let(:muxing) { Bitmovin::Encoding::Encodings::Muxings::Drms::TsMuxingAesEncryption.new('encoding-id', 'ts_id', muxing_json) }
  subject { muxing }

  it { should respond_to(:id) }
  it { should respond_to(:name) }
  it { should respond_to(:description) }
  it { should respond_to(:outputs) }
  it { should respond_to(:method) }
  it { should respond_to(:key_file_uri) }
  it { should respond_to(:key) }
  it { should respond_to(:iv) }
  it { should_not respond_to(:streams) }
  it { should respond_to(:build_output).with(0..1).argument }

  it "should have correct EncryptionType" do
    expect(subject.class.resource_path).to eq("/v1/encoding/encodings/encoding-id/muxings/ts/ts_id/drm/aes")
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

  describe "collect_attributes" do
    subject { muxing.send(:collect_attributes) }
    it "should correctly collect outputs" do
      expect(subject["outputs"]).to be_a(Array)
      expect(subject["outputs"].first).to be_a(Hash)
      expect(subject["outputs"].first["outputId"]).to eq("55354be6-0237-42bb-ae85-a2d4ef1ed19e")
      expect(subject["outputs"].first["outputPath"]).to eq("/encodings/movies/movie-1/video_720/")
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

  #assert_list_call(:get, "encoding/encodings/encoding-id/muxings/ts/drm/aes", Bitmovin::Encoding::Encodings::Muxings::Ts::Drm::TsMuxingAesEncryption)
end
