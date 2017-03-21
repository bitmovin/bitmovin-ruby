require "spec_helper"

describe Bitmovin::Encoding::Manifests::DashRepresentations do
  subject { Bitmovin::Encoding::Manifests::DashRepresentations.new('manifest-id') }

  it { should respond_to(:fmp4) }
  it { should respond_to(:webm) }
end
