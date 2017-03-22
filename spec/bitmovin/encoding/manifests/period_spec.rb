require "spec_helper"

describe Bitmovin::Encoding::Manifests::Period do
  let(:period) { Bitmovin::Encoding::Manifests::Period.new('manifest-id', { id: '7d8b38d5-9f59-4ede-a4f8-d6e822bcba9b' }) }
  subject { period }

  it { should respond_to(:video_adaptationsets) }
  it { should respond_to(:audio_adaptationsets) }

  describe "video_adaptationsets" do
    subject { period.video_adaptationsets }

    before(:each) do
      stub_request(:get, /.*#{"/v1/encoding/manifests/dash/manifest-id/periods/#{period.id}/adaptationsets/video"}/)
        .to_return(body: response_envelope({ items: [{ id: 'video' }]}).to_json)
    end

    it "should query /v1/encoding/manifests/dash/<manifest-id>/periods/<period-id>/adaptations/video" do
      expect(subject).to have_requested(:get, /.*#{"/v1/encoding/manifests/dash/manifest-id/periods/#{period.id}/adaptationsets/video"}/)
    end

    it "should return an Array" do
      expect(subject).to be_a(Array)
    end
    it "should return an Array of AdaptationSets" do
      expect(subject.first).to be_a(Bitmovin::Encoding::Manifests::VideoAdaptationSet)
    end
    it "should initialize AdaptationSet with response" do
      expect(Bitmovin::Encoding::Manifests::VideoAdaptationSet).to receive(:new).with('manifest-id', period.id, { "id" => 'video' })
      subject
    end

    context "unpersisted period" do
      let(:period) { Bitmovin::Encoding::Manifests::Period.new('manifest-id') }
      it "should raise error" do
        expect { period.video_adaptationsets }.to raise_error("Period is not persisted yet - can't load video_adaptationsets")
      end
    end
  end

  describe "audio_adaptationsets" do
    subject { period.audio_adaptationsets }

    before(:each) do
      stub_request(:get, /.*#{"/v1/encoding/manifests/dash/manifest-id/periods/#{period.id}/adaptationsets/audio"}/)
        .to_return(body: response_envelope({ items: [{ id: 'video' }]}).to_json)
    end

    it "should query /v1/encoding/manifests/dash/<manifest-id>/periods/<period-id>/adaptations/audio" do
      expect(subject).to have_requested(:get, /.*#{"/v1/encoding/manifests/dash/manifest-id/periods/#{period.id}/adaptationsets/audio"}/)
    end

    it "should return an Array" do
      expect(subject).to be_a(Array)
    end
    it "should return an Array of AdaptationSets" do
      expect(subject.first).to be_a(Bitmovin::Encoding::Manifests::AudioAdaptationSet)
    end
    it "should initialize AdaptationSet with response" do
      expect(Bitmovin::Encoding::Manifests::AudioAdaptationSet).to receive(:new).with('manifest-id', period.id, { "id" => 'video' })
      subject
    end

    context "unpersisted period" do
      let(:period) { Bitmovin::Encoding::Manifests::Period.new('manifest-id') }
      it "should raise error" do
        expect { period.audio_adaptationsets }.to raise_error("Period is not persisted yet - can't load audio_adaptationsets")
      end
    end
  end

  it { should respond_to(:build_video_adaptationset).with(0..1).arguments }
  describe "build_video_adaptationset" do
    let(:hash) { { id: 'test' } }
    subject { period.build_video_adaptationset(hash) }
    it "should return VideoAdaptationSet" do
      expect(subject).to be_a(Bitmovin::Encoding::Manifests::VideoAdaptationSet)
    end

    it "should pass hash to adaptationset" do
      expect(Bitmovin::Encoding::Manifests::VideoAdaptationSet).to receive(:new).with('manifest-id', period.id, hash)
      subject
    end

    context "unpersisted period" do
      let(:period) { Bitmovin::Encoding::Manifests::Period.new('manifest-id') }
      it "should raise error" do
        expect { period.build_video_adaptationset }.to raise_error("Period is not persisted yet - can't create video_adaptationset")
      end
    end
  end

  it { should respond_to(:build_audio_adaptationset).with(0..1).arguments }
  describe "build_audio_adaptationset" do
    let(:hash) { { id: 'test' } }
    subject { period.build_audio_adaptationset(hash) }
    it "should return audioAdaptationSet" do
      expect(subject).to be_a(Bitmovin::Encoding::Manifests::AudioAdaptationSet)
    end

    it "should pass hash to adaptationset" do
      expect(Bitmovin::Encoding::Manifests::AudioAdaptationSet).to receive(:new).with('manifest-id', period.id, hash)
      subject
    end

    context "with unpersisted period" do
      let(:period) { Bitmovin::Encoding::Manifests::Period.new('manifest-id') }
      it "should raise error" do
        expect { period.build_audio_adaptationset }.to raise_error("Period is not persisted yet - can't create audio_adaptationset")
      end
    end
  end

  describe "persisted?" do
    let(:period) { Bitmovin::Encoding::Manifests::Period.new('manifest-id') }
    let(:persisted_period) { Bitmovin::Encoding::Manifests::Period.new('manifest-id', { id: 'fff' }) }
    it "returns true if id is set" do
      expect(persisted_period).to be_persisted
    end
    it "return false if id is not set" do
      expect(period).to_not be_persisted
    end
  end
end
