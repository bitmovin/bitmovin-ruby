require "spec_helper"

describe Bitmovin::Encoding::Encodings::MuxingList do
  let(:muxing_list) { Bitmovin::Encoding::Encodings::MuxingList.new('encoding-id') }
  subject { muxing_list }

  [:fmp4, :ts, :mp4, :webm].each do |muxing|
    it { should respond_to(muxing) }

    describe(muxing) do
      subject { muxing_list.send(muxing) }
      it "should have correct encoding_id" do
        expect(subject.encoding_id).to eq(muxing_list.encoding_id)
      end

      it "#{muxing} should return #{muxing.to_s.camelize}List" do
        expect(subject).to be_a("Bitmovin::Encoding::Encodings::Muxings::#{muxing.to_s.camelize}MuxingList".constantize)
      end

      it { should respond_to(:find).with(1).argument }
      it { should respond_to(:list).with(0..2).arguments }
    end
  end

  #it { should respond_to(:list) }
  #it { should respond_to(:find).with(1).argument }
  #it { should respond_to(:add).with(1).argument }
  #it { should respond_to(:build) }

  #let(:muxing) {
  #  {
  #    id: 'muxing-id',
  #    some: :values
  #  }
  #}

  #describe "list" do
  #  subject { muxing_list.list }
  #  before(:each) do
  #    stub_request(:get, /.*#{"/v1/encoding/encodings/encoding-id/muxings"}.*/)
  #      .to_return(body: response_envelope(items: [muxing]).to_json)
  #  end

  #  it "should call GET /v1/encoding/encodings/<encoding-id>/muxings" do
  #    expect(subject).to have_requested(:get, /.*#{"/v1/encoding/encodings/encoding-id/muxings"}.*/)
  #  end

  #  it "should return Array" do
  #    expect(subject).to be_a(Array)
  #  end
  #  it "should return Array of muxings" do
  #    expect(subject.first).to be_a(Bitmovin::Encoding::Encodings::muxing)
  #  end
  #  it "should return Array of muxings with correct encoding_id" do
  #    expect(subject.first.encoding_id).to eq(muxing_list.encoding_id)
  #  end
  #  it "should return Array of muxings with correct muxing id" do
  #    expect(subject.first.id).to eq(muxing[:id])
  #  end
  #end

  #describe "build" do
  #  subject { muxing_list.build }
  #  it "should return muxing" do
  #    expect(subject).to be_a(Bitmovin::Encoding::Encodings::muxing)
  #  end
  #  it "should create muxing with correct encoding_id" do
  #    expect(subject.encoding_id).to eq(muxing_list.encoding_id)
  #  end
  #  it "should accept hash arguments" do
  #    expect(muxing_list).to respond_to(:build).with(0..1).arguments
  #  end
  #  it "should pass hash arguments to muxing.new" do
  #    args = { foo: :bar }
  #    expect(Bitmovin::Encoding::Encodings::muxing).to receive(:new).with(muxing_list.encoding_id, args)

  #    muxing_list.build(args)
  #  end
  #end

  #describe "find" do
  #  subject { muxing_list.find('muxing-id') }

  #  before(:each) do
  #    stub_request(:get, /.*#{"/v1/encoding/encodings/encoding-id/muxings/muxing-id"}.*/)
  #      .to_return(body: response_envelope(muxing).to_json)
  #  end

  #  it "should return a muxing" do
  #    expect(subject).to be_a(Bitmovin::Encoding::Encodings::muxing)
  #  end

  #  it "should call GET /v1/encoding/encodings/<encoding-id>/muxings/<muxing-id>" do
  #    expect(subject).to have_requested(:get, /.*#{"/v1/encoding/encodings/encoding-id/muxings/muxing-id"}.*/)
  #  end
  #end

  #describe "add" do
  #  subject { muxing_list.add('test') }
  #  it "should raise not implemented error" do
  #    expect { subject }.to raise_error("Not implemented yet. Please use #build and muxing#save! for the time being")
  #  end
  #end
end
