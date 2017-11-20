require "spec_helper"

describe Bitmovin::Encoding::Encodings::Muxings::Drms::TsMuxingAesEncryptionList do
  let(:list) { Bitmovin::Encoding::Encodings::Muxings::Drms::TsMuxingAesEncryptionList.new('encoding-id', 'muxing-id') }
  subject { list }
  it { should respond_to(:list).with(0..2).arguments }
  it { should respond_to(:find).with(1).argument }
  it { should respond_to(:find).with(1).argument }
  it { should respond_to(:encoding_id) }
  it { should respond_to(:muxing_id) }

  it "should have correct encoding_id" do
    expect(subject.encoding_id).to eq("encoding-id")
  end
  it "should have correct muxing_id" do
    expect(subject.muxing_id).to eq("muxing-id")
  end
end
