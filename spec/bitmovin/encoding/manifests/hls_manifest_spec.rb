require "spec_helper"

describe Bitmovin::Encoding::Manifests::HlsManifest do
  subject { Bitmovin::Encoding::Manifests::HlsManifest }
  it { should respond_to(:list).with(0..2).arguments }

  describe "instance" do
    subject { Bitmovin::Encoding::Manifests::HlsManifest.new }
    it { should respond_to(:id) }
    it { should respond_to(:name) }
    it { should respond_to(:description) }
    it { should respond_to(:created_at) }
    it { should respond_to(:modified_at) }
    it { should respond_to(:outputs) }
    it { should respond_to(:manifest_name) }
    it { should be_a(Bitmovin::Resource) }
  end
end
