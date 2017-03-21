require "spec_helper"

describe Bitmovin::Encoding::Manifests do
  let(:adaptationset) { Bitmovin::Encoding::Manifests::DashAdaptationset.new('manifest-id') }
  subject { adaptationset }
  it { should respond_to(:video) }
  it { should respond_to(:audio) }
  it "should return correct manfiest-id" do
    expect(subject.manifest_id).to eq("manifest-id")
  end
  it "video should be a Array" do
    expect(subject.video).to be_a(Array)
  end
  it "audio should be a Array" do
    expect(subject.audio).to be_a(Array)
  end

  it { should respond_to(:build_audio_adaptation).with(0..1).arguments }
  it { should respond_to(:build_video_adaptation).with(0..1).arguments }
  describe "build_video_adaptation" do
    subject { adaptationset.build_video_adaptation }
    it { should be_a(Bitmovin::Encoding::Manifests::VideoAdaptation) }
    it "should have correct manifest_id" do
      expect(subject.manifest_id).to eq(adaptationset.manifest_id)
    end
    it "should add adaptation to @video array" do
      expect(adaptationset.video).to include(subject)
    end
    it "should forward options to VideoAdaptation" do
      pending("not implemented yet")
      expect(Bitmovin::Encoding::Manifests::VideoAdaptation).to receive(:new).with(hash)
    end
  end
end
