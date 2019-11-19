require 'spec_helper'

RSpec.describe Bitmovin::Encoding::Encodings::InputStreams::Ingest do
  let(:encoding_id) { "encoding-id" }
  let(:input_id) { "input-id" }
  let(:input_path) { "input-path" }
  let(:selection_mode) { "selection-mode" }
  let(:position) { "position" }

  subject do
    described_class.new(encoding_id,
      input_id: input_id,
      input_path: input_path,
      selection_mode: selection_mode,
      position: position
    )
  end

  it { should respond_to(:input_id) }
  it { should respond_to(:input_path) }
  it { should respond_to(:selection_mode) }
  it { should respond_to(:position) }

  context "validations" do
    context "when input_id is blank" do
      let(:input_id) { nil }

      it { is_expected.to be_invalid }
      it { expect(subject.tap(&:validate!).errors).to include("input_id cannot be blank")}
    end

    context "when input_path is blank" do
      let(:input_path) { nil }

      it { is_expected.to be_invalid }
      it { expect(subject.tap(&:validate!).errors).to include("input_path cannot be blank")}
    end

    context "when selection_mode is blank" do
      let(:selection_mode) { nil }

      it { is_expected.to be_invalid }
      it { expect(subject.tap(&:validate!).errors).to include("selection_mode cannot be blank")}
    end

    context "when position is blank" do
      let(:position) { nil }

      context "when selection_mode is AUTO" do
        let(:selection_mode) { "AUTO" }

        it { is_expected.to be_valid }
      end

      context "when selection_mode is VIDEO_RELATIVE" do
        let(:selection_mode) { "VIDEO_RELATIVE" }

        it { is_expected.to be_invalid }
        it { expect(subject.tap(&:validate!).errors).to include("position cannot be blank if selection_mode is not AUTO")}
      end
    end
  end

  it "should be serialized correctly to json" do
    expect(subject.to_json(nil)).to eq('{"encoding_id":"encoding-id","instance_resource_path":"/v1/encoding/encodings/encoding-id/input-streams/ingest","input_id":"input-id","input_path":"input-path","selection_mode":"selection-mode","position":"position","errors":[]}')
  end
end
