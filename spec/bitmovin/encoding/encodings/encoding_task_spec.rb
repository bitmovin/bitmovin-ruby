require "spec_helper"
require "resource_spec_helper"

describe Bitmovin::Encoding::Encodings::EncodingTask do
  encoding = {
      name: "VideoID-x4jldf8",
      description: "Action Movie",
      encoderVersion: "STABLE",
      cloudRegion: "GOOGLE_EUROPE_WEST_1",
      infrastructureId: "f49ecf6e-bd53-4a40-8b85-64363ee7c708",
      id: "f3177c2e-0000-4ba6-bd20-1dee353d8a72",
      status: "",
      createdAt: "2016-06-25T20:09:23.69Z",
      modifiedAt: "2016-06-25T20:09:23.69Z",
      type: "NONE"
    }
  subject { Bitmovin::Encoding::Encodings::EncodingTask }
  it { should respond_to(:list).with(0..2).arguments }
  describe "list" do
    subject { Bitmovin::Encoding::Encodings::EncodingTask.list }
    before(:each) do
      stub_request(:get, /.*#{"/v1/encoding/encodings"}.*/)
        .to_return(body: response_envelope({ items: [encoding] }).to_json)
    end

    it "should call GET /v1/encoding/encodings" do
      expect(subject).to have_requested(:get, /.*#{"/v1/encoding/encodings"}/)
    end
    it "should return array" do
      expect(subject).to be_a(Array)
    end

    it "should return list of Bitmovin::Encoding::Encodings::EncodingTask" do
      expect(subject.first).to be_a(Bitmovin::Encoding::Encodings::EncodingTask)
    end
  end

  describe "instance" do
    subject { Bitmovin::Encoding::Encodings::EncodingTask.new(encoding) }
    it { should respond_to(:id) }
    it { should respond_to(:name) }
    it { should respond_to(:description) }
    it { should respond_to(:encoder_version) }
    it { should respond_to(:cloud_region) }
    it { should respond_to(:infrastructure_id) }
    it { should respond_to(:id) }
    it { should respond_to(:status) }
    it { should respond_to(:created_at) }
    it { should respond_to(:modified_at) }
    it { should respond_to(:type) }
    it { should respond_to(:live?) }
    it { should respond_to(:vod?) }

    it { should respond_to(:streams) }

    it { should respond_to(:muxings) }

    it "vod? should return true if type is vod" do
      subject.type = "VOD"
      expect(subject.vod?).to be_truthy
      expect(subject.live?).to be_falsy
    end
    it "live? should return true if type is live" do
      subject.type = "LIVE"
      expect(subject.live?).to be_truthy
      expect(subject.vod?).to be_falsy
    end

    it "streams should return a StreamList" do
      expect(subject.streams).to be_a(Bitmovin::Encoding::Encodings::StreamList)
      expect(subject.streams.encoding_id).to eq(subject.id)
    end

    it "muxings should return a MuxingList" do
      expect(subject.muxings).to be_a(Bitmovin::Encoding::Encodings::MuxingList)
      expect(subject.muxings.encoding_id).to eq(subject.id)
    end
  end

  test_resource_methods(Bitmovin::Encoding::Encodings::EncodingTask, "/v1/encoding/encodings", {
    list: response_envelope({ items: [encoding]}),
    detail: response_envelope(encoding),
    item: ActiveSupport::HashWithIndifferentAccess.new(encoding)
  })
end
