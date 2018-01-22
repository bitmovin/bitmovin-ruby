require "spec_helper"

describe Bitmovin::Encoding::Encodings::Sprite do
  let (:sprite_json) {
    {
        name: 'MySpriteName',
        description: 'This is the sprite created during encoding',
        distance: 10,
        sprite_name: 'mySprite.png',
        vtt_name: 'mySprite.vtt',
        height: 144,
        width: 256,
        outputs: [{
                      output_id: '1d314872-b50c-4c18-961a-3295606b1aba',
                      output_path: File.join('your/output/path', 'sprites')
                  }]
    }
  }

  let(:sprite) {Bitmovin::Encoding::Encodings::Sprite.new('encodingId',
                                                          'streamId',
                                                          sprite_json)}
  subject {sprite}
  it {should respond_to(:valid?)}
  it {should respond_to(:invalid?)}
  it {should respond_to(:outputs)}
  it {should respond_to(:height)}
  it {should respond_to(:distance)}
  it {should respond_to(:vtt_name)}
  it {should respond_to(:outputs)}
  it {should respond_to(:sprite_name)}
  it {should respond_to(:errors)}

  describe 'validation' do
    it 'should be valid with the given json' do
      expect(subject).to be_valid
    end

    it 'should be invalid without height set' do
      subject.height = nil
      expect(subject).to be_invalid
    end

    it 'should be invalid with height less than 0' do
      subject.height = -15
      expect(subject).to be_invalid
    end

    it 'should be invalid without vtt_name set' do
      subject.vtt_name = nil
      expect(subject).to be_invalid
    end

    it 'should be invalid with blank vtt_name set' do
      subject.vtt_name = '   '
      expect(subject).to be_invalid
    end

    it 'should be invalid without width set' do
      subject.width = nil
      expect(subject).to be_invalid
    end

    it 'should be invalid with width less than 0' do
      subject.width = -15
      expect(subject).to be_invalid
    end

    it 'should be invalid without sprite_name set' do
      subject.sprite_name = nil
      expect(subject).to be_invalid
    end

    it 'should be invalid with blank sprite_name' do
      subject.sprite_name = '   '
      expect(subject).to be_invalid
    end

    it 'should be invalid with distance less than 0' do
      subject.distance = -1
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

  end
end
