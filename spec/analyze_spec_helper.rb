require "spec_helper"

def test_analyze_method(klass, path)
  describe klass do
    it "should respond to analyze!" do
      expect(klass.new({ id: 'input-id' })).to respond_to(:analyze!)
    end
    describe "analyze!" do
      subject { klass.new({ id: 'input-id' }) }

      before(:each) do
        stub_request(:post, /.*#{File.join(path, 'input-id', 'analysis')}/)
          .with(body: { path: '/path/to/mediafile.mp4', cloudRegion: 'AWS_EU_WEST_1' })
          .to_return({ body: response_envelope({ id: 'analysis-id' }).to_json })
      end

      it "should call #{path}/analysis" do
        expect(subject.analyze!({ path: '/path/to/mediafile.mp4', cloud_region: 'AWS_EU_WEST_1' })).to have_requested(:post, /.*#{File.join(path, 'input-id', 'analysis')}/)
          .with(body: { path: '/path/to/mediafile.mp4', cloudRegion: 'AWS_EU_WEST_1' })
      end

      it "should return analysis object" do
        expect(subject.analyze!({ path: '/path/to/mediafile.mp4', cloud_region: 'AWS_EU_WEST_1' })).to be_a(Bitmovin::Encoding::Inputs::Analysis)
      end
    end
  end
end
