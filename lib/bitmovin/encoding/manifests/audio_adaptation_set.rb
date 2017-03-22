module Bitmovin::Encoding::Manifests
  class AudioAdaptationSet < Bitmovin::Resource
    def initialize(manifest_id, period_id, hash = {})
      @manifest_id = manifest_id
      @period_id = period_id
    end

    attr_accessor :manifest_id
    attr_accessor :period_id
  end
end
