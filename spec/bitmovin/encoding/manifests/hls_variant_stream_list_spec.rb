require 'spec_helper'

describe Bitmovin::Encoding::Manifests::HlsVariantStreamList do
  let(:list) { Bitmovin::Encoding::Manifests::HlsVariantStreamList.new('manifest-id') }
  subject { list }
  it { should respond_to(:list).with(0..2).arguments }
  it { should respond_to(:build).with(0..1).arguments }
  
  describe :build do
    subject { list.build }
    it "should have correct manifest_id set" do
      expect(subject.manifest_id).to eq("manifest-id")
    end
    it { should be_a(Bitmovin::Encoding::Manifests::HlsVariantStream) }
  end
end
