require "spec_helper"

describe Bitmovin::Encoding::Manifests::DashManifest do
  subject { Bitmovin::Encoding::Manifests::DashManifest }
  it { should respond_to(:list).with(0..2).arguments }

  describe "instance" do
    let(:manifest) { Bitmovin::Encoding::Manifests::DashManifest.new }
    subject { manifest }
    it { should respond_to(:id) }
    it { should respond_to(:name) }
    it { should respond_to(:description) }
    it { should respond_to(:created_at) }
    it { should respond_to(:modified_at) }
    it { should respond_to(:outputs) }
    it { should respond_to(:manifest_name) }
    it { should be_a(Bitmovin::Resource) }
    it { should respond_to(:adaptationsets) }

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
      let(:manifest) { Bitmovin::Encoding::Manifests::DashManifest.new({ id: 'encoding-id',
                                                                         outputs: [output_json]}) }
      subject { manifest.outputs }

      it { should be_a(Array) }
      it "should contain StreamOutput" do
        expect(manifest).to have(1).outputs
        expect(subject.first).to be_a(Bitmovin::Encoding::Encodings::StreamOutput)
      end

      it "should initialize StreamOutput correctly" do
        expect(subject.first.output_id).to eq("55354be6-0237-42bb-ae85-a2d4ef1ed19e")
        expect(subject.first.output_path).to eq("/encodings/movies/movie-1/video_720/")
        expect(subject.first.acl).to be_a(Array)
        expect(subject.first.acl.first[:permission]).to eq("PUBLIC_READ")
      end
    end

    describe "collect_attributes" do
      let(:manifest) { Bitmovin::Encoding::Manifests::DashManifest.new({
                                                                         name: 'test-manifest',
                                                                         manifest_name: 'manifest_name',
                                                                         outputs: [output_json]}) }
      subject { manifest.send(:collect_attributes) }
      it "should correctly collect name" do
        expect(subject["name"]).to eq('test-manifest')
      end
      it "should correctly collect outputs" do
        output = subject["outputs"].first
        expect(subject["outputs"]).to be_a(Array)
        expect(output).to be_a(Hash)
        expect(output["outputId"]).to eq("55354be6-0237-42bb-ae85-a2d4ef1ed19e")
        expect(output["outputPath"]).to eq("/encodings/movies/movie-1/video_720/")
        expect(output["acl"]).to be_a(Array)
        expect(output["acl"].first["permission"]).to eq("PUBLIC_READ")
      end
    end

    describe "adaptationsets" do
      let(:manifest) { Bitmovin::Encoding::Manifests::DashManifest.new({ id: 'manifest-id' }) }
      subject { manifest.adaptationsets }
      it { should be_a(Bitmovin::Encoding::Manifests::DashAdaptationset) }
      it "should have correct manifest_id" do
        expect(subject.manifest_id).to eq(manifest.id)
      end
    end
  end
end
