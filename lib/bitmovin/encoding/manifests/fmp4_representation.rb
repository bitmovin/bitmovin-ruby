module Bitmovin::Encoding::Manifests
  class Fmp4Representation < Bitmovin::Resource
    def initialize(manifest_id, period_id, adaptationset_id, hash = {})
      path = File.join("/v1/encoding/manifests/dash/", manifest_id, "periods", period_id, "adaptationsets/", adaptationset_id, "representations/fmp4")
      self.class.init(path)
      super(hash)
      @manifest_id = manifest_id
      @period_id = period_id
      @adaptationset_id = adaptationset_id
    end

    attr_accessor :manifest_id
    attr_accessor :period_id
    attr_accessor :adaptationset_id

    attr_accessor :type, :encoding_id, :muxing_id, :start_segment_number, :end_segment_number, :segment_path
  end
end
