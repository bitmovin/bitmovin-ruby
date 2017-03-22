module Bitmovin::Encoding::Manifests
  class VideoAdaptationSet < Bitmovin::Resource
    def initialize(manifest_id, period_id, hash = {})
      path = File.join("/v1/encoding/manifests/dash/", manifest_id, "periods", period_id, "adaptationsets/video")
      self.class.init(path)
      @manifest_id = manifest_id
      @period_id = period_id
    end

    attr_accessor :manifest_id
    attr_accessor :period_id
    attr_accessor :roles

    def ignore_fields
      [:@manifest_id, :@period_id]
    end
  end
end
