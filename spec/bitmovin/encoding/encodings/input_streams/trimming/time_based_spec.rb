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

  before do
    allow(Bitmovin.client).to receive(:post)
      .and_return(double(body: "{\"data\":{\"result\":[]}}"))
  end

  describe "validation" do
    context "without offset" do
      let(:offset) { nil }

      it { is_expected.to be_invalid }
    end

    context "without duration" do
      let(:duration) { nil }

      it { is_expected.to be_invalid }
    end

    context "with duration less than zero" do
      let(:duration) { -1 }

      it { is_expected.to be_invalid }
    end

    context "with duration zero" do
      let(:duration) { 0 }

      it { is_expected.to be_invalid }
    end

    context "without input_stream_id" do
      let(:input_stream_id) { nil }

      it { is_expected.to be_invalid }
    end

    it "should be valid if all is set" do
      expect(subject).to be_valid
    end

    context "when invalid" do
      let(:duration) { 0 }

      it "does not save" do
        expect(Bitmovin.client).to_not receive(:post)

        subject.save!
      end
    end

    context "when valid" do
      it "saves" do
        expect(Bitmovin.client).to receive(:post)

        subject.save!
      end
    end
  end

  it "should be serialized correctly to json" do
    expect(subject.to_json(nil)).to eq('{"encoding_id":"encoding-id","instance_resource_path":"/v1/encoding/encodings/encoding-id/input-streams/trimming/time-based","input_stream_id":"input-stream-id","offset":10,"duration":120,"errors":[]}')
  end
end
