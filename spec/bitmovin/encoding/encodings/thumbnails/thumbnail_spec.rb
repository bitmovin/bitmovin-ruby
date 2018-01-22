require "spec_helper"

describe Bitmovin::Encoding::Encodings::Thumbnail do

  let (:thumbnail_json) {
    {
        positions: [5, 10 , 15, 20, 25],
        height: 320,
        pattern: 'thumb_%number%.png',
        outputs: [{
                      output_id: 'f5bc7ce3-3788-46ce-99e4-28b4d049d35b',
                      output_path: File.join('your/output/path/', 'thumbnails')
                  }]
    }
  }

  let(:thumbnail) { Bitmovin::Encoding::Encodings::Thumbnail.new('encodingId',
                                                                 'streamId',
                                                                 thumbnail_json) }
  subject { thumbnail }
  it { should respond_to(:valid?) }
  it { should respond_to(:invalid?) }
  it { should respond_to(:outputs) }
  it { should respond_to(:unit) }
  it { should respond_to(:pattern) }
  it { should respond_to(:height) }
  it { should respond_to(:positions) }
  it { should respond_to(:errors) }

  describe 'validation' do
    it 'should be valid with the given json' do
      expect(subject).to be_valid
    end

    it 'should be invalid with empty positions' do
      subject.positions = []
      expect(subject).to be_invalid
      expect(subject.errors.length).to be(1)
      expect(subject.errors[0]).to eq('There has to be at least one position for a thumbnail')
    end

    it 'should be invalid with positions set to nil' do
      subject.positions = nil
      expect(subject).to be_invalid
      expect(subject.errors.length).to be(1)
      expect(subject.errors[0]).to eq('There has to be at least one position for a thumbnail')
    end

    it 'should be invalid with wrong unit set' do
      subject.unit = 'SOMETHING'
      expect(subject).to be_invalid
    end

    it 'should be valid with correct PERCENT unit set' do
      subject.unit = 'PERCENTS'
      expect(subject).to be_valid
    end

    it 'should be valid with correct SECONDS unit set' do
      subject.unit = 'SECONDS'
      expect(subject).to be_valid
    end

    it 'should be invalid without height set' do
      subject.height = nil
      expect(subject).to be_invalid
    end

    it 'should be invalid with height set less than 0' do
      subject.height = -15
      expect(subject).to be_invalid
    end

    it 'should be invalid when one of the outputs is invalid' do
      subject.outputs = [Bitmovin::Encoding::StreamOutput.new({
                             output_id: '74ef4a9b-5a38-46e1-ae7e-ec58aadc721a',
                             output_path: File.join('your/output/path', 'thumbnails')
                         }),
                         Bitmovin::Encoding::StreamOutput.new({
                             output_id: '',
                             output_path: File.join('your/output/path/', 'thumbnails')
                         })]
      expect(subject).to be_invalid
    end

    it 'should be invalid without pattern set' do
      subject.pattern = nil
      expect(subject).to be_invalid
    end

    it 'should be invalid with blank pattern set' do
      subject.pattern = '   '
      expect(subject).to be_invalid
    end

  end
end
