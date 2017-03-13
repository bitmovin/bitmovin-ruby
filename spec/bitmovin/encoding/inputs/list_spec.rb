require "spec_helper"
describe Bitmovin::Encoding::Inputs do
  describe "list" do
    subject { Bitmovin::Encoding::Inputs }
    assert_list_call(:get, "encoding/inputs", Bitmovin::Encoding::Inputs::S3Input)
  end
end
