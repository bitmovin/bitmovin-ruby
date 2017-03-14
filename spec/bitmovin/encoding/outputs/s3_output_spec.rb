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

describe Bitmovin::Encoding::Outputs::S3Output do
  describe "finder methods" do
    subject { Bitmovin::Encoding::Outputs::S3Output }
    it "should respond to .list()" do
      expect(subject).to respond_to(:list).with(0..2).arguments
    end
    describe "list()" do
      subject{ Bitmovin::Encoding::Outputs::S3Output.list() }

      before(:each) do
        stub_request(:get, /.*#{"/v1/encoding/outputs/s3"}.*/)
          .to_return(body: s3_list_response.to_json)
      end
      it "should return a list" do
        expect(subject).to be_a(Array)
      end
      it "should return a list of S3Outputs" do
        expect(subject).to include(Bitmovin::Encoding::Outputs::S3Output)
      end
    end

    it "should respond to .find(<encodingId>)" do
      expect(subject).to respond_to(:find).with(1).argument
    end
    describe "find()" do
      subject { Bitmovin::Encoding::Outputs::S3Output.find('7efd17bc-c94e-4c2f-93c0-1affde88fdc2') }

      before(:each) do
        stub_request(:get, /.*#{"/v1/encoding/outputs/s3/7efd17bc-c94e-4c2f-93c0-1affde88fdc2"}.*/)
          .to_return(body: s3_detail_response.to_json)
      end

      it "should call GET /v1/encoding/outputs/s3/<id>" do
        expect(subject).to have_requested(:get, /.*#{"/v1/encoding/outputs/s3/7efd17bc-c94e-4c2f-93c0-1affde88fdc2"}.*/)
      end

      it "should return a S3Output" do
        expect(subject).to be_a(Bitmovin::Encoding::Outputs::S3Output)
      end

      it "should be initialized with correct values from response" do
        expect(Bitmovin::Encoding::Outputs::S3Output).to receive(:new).with(s3_detail)
        subject
      end
    end
  end

  describe "instance methods" do
    subject { Bitmovin::Encoding::Outputs::S3Output.new(s3_detail) }

    describe 'new' do
      it "should initialize all properties from hash" do
        expect(subject.id).to eq(s3_detail[:id])
        expect(subject.name).to eq(s3_detail[:name])
        expect(subject.cloud_region).to eq(s3_detail[:cloudRegion])
        expect(subject.description).to eq(s3_detail[:description])
        expect(subject.bucket_name).to eq(s3_detail[:bucketName])
      end
    end

    it "should respond to .delete()" do
      expect(subject).to respond_to(:delete).with(0).arguments
    end

    describe "delete()" do
      before(:each) do
      stub_request(:delete, /.*#{"/v1/encoding/outputs/s3/7efd17bc-c94e-4c2f-93c0-1affde88fdc2"}.*/)
      end
      it "should call DELETE /v1/encoding/outputs/s3/<id>" do
        expect(subject.delete()).to have_requested(:delete, /.*#{"/v1/encoding/outputs/s3/7efd17bc-c94e-4c2f-93c0-1affde88fdc2"}.*/)
      end
    end

    describe "inspect" do
      it "should output Bitmovin::Encoding::Outputs::S3Output(id, name)" do
        expect(subject.inspect).to eq("Bitmovin::Encoding::Outputs::S3Output(id: #{s3_detail[:id]}, name: #{s3_detail[:name]})")
      end
    end
  end
end
