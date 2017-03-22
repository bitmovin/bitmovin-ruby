require "spec_helper"

describe Bitmovin::Encoding::Manifests::AudioAdaptationSet do
  context "unpersisted" do
    subject do
      x = Bitmovin::Encoding::Manifests::AudioAdaptationSet.new('manifest-id', 'period-id')
      x.roles = ["ALTERNATE"]
      x.lang = "en"
      x
    end
    it { should_not be_persisted }
    it { should respond_to(:roles) }
    it { should respond_to(:lang) }
    it { should respond_to(:id) }

    describe "save" do
      let(:json) { { roles: ["ALTERNATE"], lang: "en" }.to_json }
      before(:each) do
        stub_request(:post, /.*#{"/v1/encoding/manifests/dash/manifest-id/periods/period-id/adaptationsets/audio"}/)
          .with(body: json)
          .to_return(body: response_envelope({ id: 'test' }).to_json)
      end

      it "should call POST /v1/encoding/manfiests/<manifest-id>/periods/<period-id>/adaptationsets/audio" do
        expect(subject.save!).to have_requested(:post, /.*#{"/v1/encoding/manifests/dash/manifest-id/periods/period-id/adaptationsets/audio"}/)
          .with(body: json)
      end

      it "should read returned id" do
        subject.save!
        expect(subject.id).to eq('test')
      end

      it "should be persisted after save" do
        subject.save!
        expect(subject).to be_persisted
      end
    end
  end
end
