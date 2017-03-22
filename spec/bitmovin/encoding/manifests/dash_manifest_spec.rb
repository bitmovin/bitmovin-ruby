require "spec_helper"

describe Bitmovin::Encoding::Manifests::DashManifest do
  subject { Bitmovin::Encoding::Manifests::DashManifest }
  it { should respond_to(:list).with(0..2).arguments }

  describe "instance" do
    let(:manifest) { Bitmovin::Encoding::Manifests::DashManifest.new }
    let(:manifest_with_id) { Bitmovin::Encoding::Manifests::DashManifest.new(id: 'manifest-id') }
    subject { manifest }
    it { should respond_to(:id) }
    it { should respond_to(:name) }
    it { should respond_to(:description) }
    it { should respond_to(:created_at) }
    it { should respond_to(:modified_at) }
    it { should respond_to(:periods) }
    it { should respond_to(:build_period) }

    it { should respond_to(:outputs) }
    it { should respond_to(:manifest_name) }
    it { should be_a(Bitmovin::Resource) }
    it { should respond_to(:reload!) }

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

    describe "reload" do
      it "should clear @periods" do
        subject.instance_variable_set(:@periods, [])
        subject.reload!
        expect(subject.instance_variable_get(:@periods)).to be_nil
      end
    end

    describe "periods" do
      it "should fetch periods if not loaded yet" do
        allow(subject).to receive(:persisted?).and_return(true)
        expect(subject).to receive(:load_periods).and_return([])
        subject.periods
      end
      it "should not reload periods if already loaded" do
        allow(subject).to receive(:persisted?).and_return(true)
        expect(subject).to receive(:load_periods).exactly(1).and_return([])
        2.times { subject.periods }
      end
    end

    describe "load_periods" do
      subject { Bitmovin::Encoding::Manifests::DashManifest.new({ id: 'manifest-id' }) }
      before(:each) do
        stub_request(:get, /.*#{"/v1/encoding/manifests/dash/manifest-id/periods"}/)
          .and_return(body: response_envelope({ items: [{foo: :bar}, {test: :item}] }).to_json)
      end

      it "should call /v1/encoding/manifests/dash/<manifest-id>/periods" do
        expect(subject.send(:load_periods)).to have_requested(:get, /.*#{"/v1/encoding/manifests/dash/manifest-id/periods"}/)
      end

      it "should call Period.new for each item" do
        expect(Bitmovin::Encoding::Manifests::Period).to receive(:new).twice.with('manifest-id', any_args)
        subject.send(:load_periods)
      end

      it "should raise an error if dash manifest is not persisted" do
        manifest = Bitmovin::Encoding::Manifests::DashManifest.new
        expect { manifest.periods }.to raise_error("DashManifest is not persisted yet - can't load periods")
      end
    end

    describe "build_period" do
      subject { manifest_with_id.build_period }
      it { should be_a(Bitmovin::Encoding::Manifests::Period) }
      it "should return correct manifest_id" do
        expect(subject.manifest_id).to eq(manifest_with_id.id)
      end
    end

    #describe "representations" do
    #  let(:manifest) { Bitmovin::Encoding::Manifests::DashManifest.new({ id: 'test' }) }
    #  subject { manifest.representations }
    #  it { should be_a(Bitmovin::Encoding::Manifests::DashRepresentations) }
    #  it "should set correct manifest-id" do
    #    expect(subject.manifest_id).to eq('test')
    #  end
    #end
    describe "outputs" do
      let(:manifest) { Bitmovin::Encoding::Manifests::DashManifest.new({ id: 'encoding-id',
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

    describe "persisted" do
      it "should be true for manifests with set id" do
        expect(manifest_with_id.persisted?).to be_truthy
      end
      it "should be false for manifests without id" do
        expect(manifest.persisted?).to be_falsy
      end
    end
  end
end
