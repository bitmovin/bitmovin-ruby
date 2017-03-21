require "spec_helper"

describe Bitmovin::Encoding::Manifests do
  subject { Bitmovin::Encoding::Manifests }
  it { should respond_to(:list).with(0..2).arguments }
  it { should respond_to(:dash).with(0).arguments }
  it { should respond_to(:hls).with(0).arguments }
end
