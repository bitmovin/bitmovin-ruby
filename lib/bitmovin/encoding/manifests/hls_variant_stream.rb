module Bitmovin::Encoding::Manifests
  class HlsVariantStream < Bitmovin::Resource
    attr_accessor :id, :manifest_id

    # Required
    attr_accessor :closed_captions, :segment_path, :uri
    attr_accessor :encoding_id, :stream_id, :muxing_id

    attr_accessor :audio, :video, :subtitles
    attr_accessor :drm_id, :start_segment_number, :end_segment_number


    def initialize(manifest_id, hash = {})
      hsh = ActiveSupport::HashWithIndifferentAccess.new(underscore_hash(hash))
      @manifest_id = manifest_id
      self.class.init(File.join("/v1/encoding/manifests/hls/", manifest_id, "streams"))
      super(hsh)
    end
  end
end
