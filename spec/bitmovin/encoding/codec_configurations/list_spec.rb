require "spec_helper"
describe Bitmovin::Encoding::CodecConfigurations do
  describe "list" do
    subject { Bitmovin::Encoding::CodecConfigurations }
    it { should respond_to(:list).with(0..2).arguments }
    url = /.*#{"/v1/encoding/configurations"}.*/
    let(:sample_list_body) {
      response_envelope({
        items: [
          {
            type: 'h264',
            id: SecureRandom.hex,
            name: 'test',
            description: 'desc',
            width: 100,
            height: 200,
            bitrate: 100000,
            rate: 23.97,
            profile: 'BASELINE',
            bframes: 3,
            refFrames: 5,
            qpMin: 0,
            qpMax: 69,
            mvPredictionMode: 'AUTO',
            mvSearchRangeMax: 16,
            cabac: true,
            maxBitrate: 0,
            minBitrate: 0,
            bufsize: 0
          },
          {
            type: 'aac',
            id: SecureRandom.hex,
            name: 'test',
            description: 'desc'
          },
          {
            type: 'h265',
            id: SecureRandom.hex,
            name: 'test',
            description: 'desc'
          },
          {
            type: 'vp9',
            id: SecureRandom.hex,
            name: 'test',
            description: 'desc'
          }
        ]
      })
    }

    describe "list()" do
      it "should call GET #{url}" do
        stub_request(:get, url).to_return(sample_list_body_http)
        expect(subject.list(100, 0)).to have_requested(:get, url)
      end
    end
    it "should return a list" do
      stub_request(:get, url).to_return(body: sample_list_body.to_json)
      response = subject.list()
      expect(response).to be_a(Array)
    end
    it "should return a list including Bitmovin::Encoding::CodecConfigurations::H264Configuration" do
      stub_request(:get, url).to_return(body: sample_list_body.to_json)
      response = subject.list()
      expect(response).to include(be_a(Bitmovin::Encoding::CodecConfigurations::H264Configuration))
    end
    it "should return a list including Bitmovin::Encoding::CodecConfigurations::H265Configuration" do
      stub_request(:get, url).to_return(body: sample_list_body.to_json)
      response = subject.list()
      expect(response).to include(be_a(Bitmovin::Encoding::CodecConfigurations::H265Configuration))
    end
    it "should return a list including Bitmovin::Encoding::CodecConfigurations::AacConfiguration" do
      stub_request(:get, url).to_return(body: sample_list_body.to_json)
      response = subject.list()
      expect(response).to include(be_a(Bitmovin::Encoding::CodecConfigurations::AacConfiguration))
    end
    it "should return a list including Bitmovin::Encoding::CodecConfigurations::Vp9Configuration" do
      stub_request(:get, url).to_return(body: sample_list_body.to_json)
      response = subject.list()
      expect(response).to include(be_a(Bitmovin::Encoding::CodecConfigurations::Vp9Configuration))
    end
    it "should return list with correct size" do
      stub_request(:get, url).to_return(body: sample_list_body.to_json)
      response = subject.list()
      expect(response.size).to eq(4)
    end
  end
end
