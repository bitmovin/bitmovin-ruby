require 'spec_helper'

describe Bitmovin::Encoding::Manifests::HlsVariantStream do
  let(:response_json) {
    {
      "id": "some-id",
      "audio": "audio_group",
      "video": "video_group",
      "subtitles": "subtitles_group",
      "closedCaptions": "NONE",
      "segmentPath": "path/to/segments",
      "uri": "playlist.m3u8",
      "encodingId": "cb90b80c-8867-4e3b-8479-174aa2843f62",
      "streamId": "cb90b80c-8867-4e3b-8479-174aa2843f62",
      "muxingId": "cb90b80c-8867-4e3b-8479-174aa2843f62",
      "drmId": "cb90b80c-8867-4e3b-8479-174aa2843f62",
      "startSegmentNumber": 0,
      "endSegmentNumber": 4603
    }
  }
  let(:stream) { Bitmovin::Encoding::Manifests::HlsVariantStream.new('manifest-id', response_json) }

  subject { stream }

  it { should respond_to(:id) }
  it { should respond_to(:manifest_id) }
  it { should respond_to(:audio) }
  it { should respond_to(:video) }
  it { should respond_to(:subtitles) }
  it { should respond_to(:closed_captions) }
  it { should respond_to(:segment_path) }
  it { should respond_to(:uri) }
  it { should respond_to(:encoding_id) }
  it { should respond_to(:stream_id) }
  it { should respond_to(:drm_id) }
  it { should respond_to(:start_segment_number) }
  it { should respond_to(:end_segment_number) }
  it { should respond_to(:save!) }

  describe :save do
    subject { stream.dup.tap{ |x| x.id = nil } }
    #it "should call POST /v1/encoding/manifests/<manifest-id>/streams" do
    #  resp = response_envelope(response_json).to_json
    #  body = { drm_id: 'foo' }
    #  stub_request(:post, /.*#{"v1/encoding/manifests/manifest-id/streams"}/)
    #    .with(body: body.to_json)
    #    .to_return(body: resp)

    #  expect(subject.save!).to have_requested(:post, /.*#{"v1/encoding/manifests/manifest-id/streams"}/)
    #end
  end

end
