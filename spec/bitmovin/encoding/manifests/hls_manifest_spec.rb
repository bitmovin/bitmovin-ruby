require "spec_helper"

describe Bitmovin::Encoding::Manifests::HlsManifest do
  subject { Bitmovin::Encoding::Manifests::HlsManifest }
  it { should respond_to(:list).with(0..2).arguments }

  describe "instance" do
    let(:manifest) { Bitmovin::Encoding::Manifests::HlsManifest.new }
    let(:manifest_with_id) { Bitmovin::Encoding::Manifests::HlsManifest.new(id: 'manifest-id') }
    subject { Bitmovin::Encoding::Manifests::HlsManifest.new }
    it { should respond_to(:id) }
    it { should respond_to(:name) }
    it { should respond_to(:description) }
    it { should respond_to(:created_at) }
    it { should respond_to(:modified_at) }
    it { should respond_to(:outputs) }
    it { should respond_to(:manifest_name) }
    it { should be_a(Bitmovin::Resource) }

    it { should respond_to(:streams) }
    it { should respond_to(:audio_media) }
    it { should respond_to(:build_audio_medium) }
    it { should respond_to(:build_stream) }

    it { should respond_to(:start!) }

    let(:output_json) { 
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

    describe "outputs" do
      let(:manifest) { Bitmovin::Encoding::Manifests::HlsManifest.new({ id: 'encoding-id',
                                                                         outputs: [output_json]}) }
      subject { manifest.outputs }

      it { should be_a(Array) }
      it "should contain StreamOutput" do
        expect(manifest).to have(1).outputs
        expect(subject.first).to be_a(Bitmovin::Encoding::StreamOutput)
      end

      it "should initialize StreamOutput correctly" do
        expect(subject.first.output_id).to eq("55354be6-0237-42bb-ae85-a2d4ef1ed19e")
        expect(subject.first.output_path).to eq("/encodings/movies/movie-1/video_720/")
        expect(subject.first.acl).to be_a(Array)
        expect(subject.first.acl.first[:permission]).to eq("PUBLIC_READ")
      end
    end
  end
end
