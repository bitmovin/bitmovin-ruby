require "spec_helper"

describe Bitmovin::Encoding::Outputs do
  describe "list" do
    subject { Bitmovin::Encoding::Outputs }
    assert_list_call(:get, "encoding/outputs", Bitmovin::Encoding::Outputs::S3Output)
  end
end
