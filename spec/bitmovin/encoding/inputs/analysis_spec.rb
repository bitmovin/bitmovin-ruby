require "spec_helper"

describe Bitmovin::Encoding::Inputs::Analysis do
  subject { Bitmovin::Encoding::Inputs::Analysis.new('input-id', 'analysis-id') }

  it { should respond_to(:input_id) }
  it { should respond_to(:id) }
  it "should return given input_id" do
    expect(subject.input_id).to eq('input-id')
  end

  it "should return given analysis_id as id" do
    expect(subject.id).to eq('analysis-id')
  end

  context "given an input object" do
    let(:input) { Bitmovin::Encoding::Inputs::S3Input.new(id: 'test') }
    subject { Bitmovin::Encoding::Inputs::Analysis.new(input, 'analysis-id') }

    it 'should set input-id from input object' do
      expect(subject.input_id).to eq(input.id)
    end

    it "should respond to input" do
      expect(subject).to respond_to(:input)
    end

    it "should return input" do
      expect(subject.input).to eq(input)
    end
  end
end
