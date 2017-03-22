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
    it "should cache the result" do
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
  end
end
