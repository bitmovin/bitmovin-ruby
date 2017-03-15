require "spec_helper"

def test_analyze_method(klass, path)
  describe klass do
    it "should respond to analyze!" do
      expect(klass.new({ id: 'input-id' })).to respond_to(:analyze!)
    end
    describe "analyze!" do
      subject { klass.new({ id: 'input-id' }) }

      before(:each) do
        stub_request(:post, /.*#{File.join('/v1/encoding/inputs', 'input-id', 'analysis')}/)
          .with(body: { path: '/path/to/mediafile.mp4', cloudRegion: 'AWS_EU_WEST_1' })
          .to_return({ body: response_envelope({ id: 'analysis-id' }).to_json })
      end

      it "should call #{path}/analysis" do
        expect(subject.analyze!({ path: '/path/to/mediafile.mp4', cloud_region: 'AWS_EU_WEST_1' })).to have_requested(:post, /.*#{File.join('/v1/encoding/inputs/', 'input-id', 'analysis')}/)
          .with(body: { path: '/path/to/mediafile.mp4', cloudRegion: 'AWS_EU_WEST_1' })
      end

      it "should return analysis object" do
        expect(subject.analyze!({ path: '/path/to/mediafile.mp4', cloud_region: 'AWS_EU_WEST_1' })).to be_a(Bitmovin::Encoding::Inputs::Analysis)
      end
    end

    it "should respond to analyses" do
      expect(klass.new({ id: 'input-id' })).to respond_to(:analyses).with(0..2).arguments
    end
    describe "analyses" do
      subject { klass.new({ id: 'input-id' }) }
      let(:analysis_list) {
        (0...5).map { |i| {
          id: i.to_s,
          videoStreams: [{
            position: "100",
            id: SecureRandom.uuid,
            fps: "24",
            codec: "h264",
            testStringToUnderscore: "test"
          }],
          audioStreams: [{
          }],
          metaStreams: [{
          }],
          subtitleStreams: [{
          }],
          path: '/path/to/media/file',
          cloudRegion: 'GOOGLE_EUROPE_WEST_1'
        }}
      }

      before(:each) do
        stub_request(:get, /.*#{"v1/encoding/inputs/#{subject.id}/analysis"}\??.*/)
          .to_return(body: response_envelope(analysis_list).to_json)
      end

      it "should call GET /v1/encoding/inputs/<input_id>/analysis" do

        expect(subject.analyses).to have_requested(:get, /.*#{"v1/encoding/inputs/#{subject.id}/analysis"}\??.*/)
      end

      it "should return a list" do
        expect(subject.analyses).to be_a(Array)
        expect(subject.analyses.length).to eq(5)
      end
      it "should return a list of objects having a path" do
        expect(subject.analyses.first).to respond_to(:path)
        expect(subject.analyses.first.path).to eq('/path/to/media/file')
      end
      it "should return a list of objects having videoStreams" do
        expect(subject.analyses.first).to respond_to(:video_streams)
        expect(subject.analyses.first.video_streams).to be_a(Array)
      end
      describe "item video_streams" do
        it "should return position" do
          expect(subject.analyses.first.video_streams.first).to respond_to(:position)
          expect(subject.analyses.first.video_streams.first.position).to eq("100")
        end
        it "should camelize values in video_streams" do
          expect(subject.analyses.first.video_streams.first).to respond_to(:test_string_to_underscore)
        end
      end
    end
  end
end