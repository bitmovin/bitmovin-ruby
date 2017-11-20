require "spec_helper"

describe Bitmovin::Encoding::Encodings do
  subject { Bitmovin::Encoding::Encodings::EncodingTask }

  it { should respond_to(:list).with(0..2).arguments }
  it { should respond_to(:find) }

end
