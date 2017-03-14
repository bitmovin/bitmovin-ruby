require "spec_helper"

s3_list_response = response_envelope({
  items: [{
    id: '7efd17bc-c94e-4c2f-93c0-1affde88fdc2',
    type: 'S3',
    name: 's3 input',
    description: 'desc',
    bucketName: 'bucket',
    cloudRegion: 'EU_CENTRAL_1'
  }]
})
s3_detail = ActiveSupport::HashWithIndifferentAccess.new({
  id: '7efd17bc-c94e-4c2f-93c0-1affde88fdc2',
  name: 's3 input',
  description: 'desc',
  bucketName: 'bucket',
  cloudRegion: 'EU_CENTRAL_1'
})
s3_detail_response = response_envelope(s3_detail)

describe Bitmovin::Encoding::Inputs::S3Input do
  subject { Bitmovin::Encoding::Inputs::S3Input }

  describe "finder methods" do
    it "should respond to .list()" do
      expect(subject).to respond_to(:list).with(0..2).arguments
    end
    describe "list()" do
      subject{ Bitmovin::Encoding::Inputs::S3Input.list() }

      before(:each) do
        stub_request(:get, /.*#{"/v1/encoding/inputs/s3"}.*/)
          .to_return(body: s3_list_response.to_json)
      end
      it "should return a list" do
        expect(subject).to be_a(Array)
      end
      it "should return a list of S3Inputs" do
        expect(subject).to include(Bitmovin::Encoding::Inputs::S3Input)
      end
    end

    it "should respond to .find(<encodingId>)" do
      expect(subject).to respond_to(:find).with(1).argument
    end
    describe "find()" do
      subject { Bitmovin::Encoding::Inputs::S3Input.find('7efd17bc-c94e-4c2f-93c0-1affde88fdc2') }

      before(:each) do
        stub_request(:get, /.*#{"/v1/encoding/inputs/s3/7efd17bc-c94e-4c2f-93c0-1affde88fdc2"}.*/)
          .to_return(body: s3_detail_response.to_json)
      end

      it "should call GET /v1/encoding/inputs/s3/<id>" do
        expect(subject).to have_requested(:get, /.*#{"/v1/encoding/inputs/s3/7efd17bc-c94e-4c2f-93c0-1affde88fdc2"}.*/)
      end

      it "should return a S3Input" do
        expect(subject).to be_a(Bitmovin::Encoding::Inputs::S3Input)
      end

      it "should be initialized with correct values from response" do
        expect(Bitmovin::Encoding::Inputs::S3Input).to receive(:new).with(s3_detail)
        subject
      end
    end
  end
end
