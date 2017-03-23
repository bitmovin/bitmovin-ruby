module Bitmovin::Encoding::Manifests
  class VideoAdaptationSet < Bitmovin::Resource
    include Bitmovin::ChildCollection
    def initialize(manifest_id, period_id, hash = {})
      path = File.join("/v1/encoding/manifests/dash/", manifest_id, "periods", period_id, "adaptationsets/video")
      self.class.init(path)
      super(hash)
      @manifest_id = manifest_id
      @period_id = period_id
    end

    child_collection(:fmp4_representations, "/v1/encoding/manifests/dash/%s/periods/%s/adaptationsets/%s/representations/fmp4", [:manifest_id, :period_id, :id], Fmp4Representation)

    attr_accessor :manifest_id
    attr_accessor :period_id
    attr_accessor :roles

    def ignore_fields
      [:@manifest_id, :@period_id]
    end
  end
end
