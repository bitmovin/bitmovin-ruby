module Bitmovin::Encoding::Manifests
  class VideoAdaptation
    def initialize(manifest_id)
      @manifest_id = manifest_id
    end
    attr_accessor :manifest_id
  end
end
