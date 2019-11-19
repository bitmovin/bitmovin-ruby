require 'spec_helper'

describe Bitmovin::Encoding::Encodings::InputStreams::Trimming::TimeBased do
  let(:json) do
    {
      input_stream_id: input_stream_id,
      offset: offset,
      duration: duration,
    }
  end
  let(:encoding_id) { "encoding-id" }
  let(:input_stream_id) { "input-stream-id" }
  let(:offset) { 10 }
  let(:duration) { 120 }

  subject { described_class.new(encoding_id, json) }

  it { should respond_to(:offset) }
  it { should respond_to(:duration) }
  it { should respond_to(:valid?) }
  it { should respond_to(:errors) }

  describe "validation" do
    context "without offset" do
      let(:offset) { nil }

      it { is_expected.to be_invalid }
    end

    context "without duration" do
      let(:duration) { nil }

      it { is_expected.to be_invalid }
    end

    it "without duration should be invalid" do
      subject.duration = nil
      expect(subject).to be_invalid
    end
    it "without duration less or smaller than zero should be invalid" do
      subject.duration = 0
      expect(subject).to be_invalid
    end
    it "should be valid if all is set" do
      expect(subject).to be_valid
    end
  end

  it "should be serialized correctly to json" do
    puts subject.to_json(nil)
    expect(subject.to_json(nil)).to eq('{"encoding_id":"encoding-id","instance_resource_path":"/v1/encoding/encodings/encoding-id/input-streams/trimming/time-based","input_stream_id":"input-stream-id","offset":10,"duration":120,"errors":[]}')
  end
end
