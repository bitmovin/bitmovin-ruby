require "spec_helper"

describe Bitmovin::Encoding::Inputs::Analysis do
  let(:analysis) { Bitmovin::Encoding::Inputs::Analysis.new("input-id") }
  subject { analysis }
  it { should respond_to(:list).with(0..2).arguments }
  it { should respond_to(:find) }
  describe "find"  do
    before(:each) do
      stub_request(:get, /.*#{"/v1/encoding/inputs/input-id/analysis/analysis-id"}/)
        .to_return(body: response_envelope({
          id: SecureRandom.uuid,
          videoStreams: [{
            position: "100",
            id: SecureRandom.uuid,
            fps: "24",
            codec: "h264",
            testStringToUnderscore: "test"
          }],
          audioStreams: [{
          }],
          metaStreams: [{
          }],
          subtitleStreams: [{
          }],
          path: '/path/to/media/file',
          cloudRegion: 'GOOGLE_EUROPE_WEST_1'
        }).to_json)
    end


    subject { analysis.find('analysis-id') }
    it { should respond_to(:id) }
    it { should respond_to(:video_streams) }
    it { should respond_to(:audio_streams) }
    it { should respond_to(:meta_streams) }
    it { should respond_to(:subtitle_streams) }
    it { should respond_to(:path) }
    it { should respond_to(:cloud_region) }


    it "should call GET /v1/encoding/inputs/<input-id>/analysis/<analysis-id>" do
      expect(subject).to have_requested(:get, /.*#{"/v1/encoding/inputs/input-id/analysis/analysis-id"}/)
    end

  end
end
