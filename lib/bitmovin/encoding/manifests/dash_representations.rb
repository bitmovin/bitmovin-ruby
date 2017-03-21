module Bitmovin::Encoding::Manifests
  class DashRepresentations
    def initialize(id)
      @manifest_id = id
    end
    attr_accessor :manifest_id

    [:fmp4, :webm].each do |representation|
      define_method representation do

      end
    end
  end
end
