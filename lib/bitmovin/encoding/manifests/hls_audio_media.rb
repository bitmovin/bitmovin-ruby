module Bitmovin::Encoding::Manifests
  class HlsAudioMedia < Bitmovin::Resource
    attr_accessor :manifest_id
    attr_accessor :group_id
    attr_accessor :language
    attr_accessor :assoc_language
    attr_accessor :name
    attr_accessor :is_default
    attr_accessor :autoselect
    attr_accessor :characteristics
    attr_accessor :segment_path
    attr_accessor :encoding_id
    attr_accessor :stream_id
    attr_accessor :muxing_id
    attr_accessor :drm_id
    attr_accessor :start_segment_number
    attr_accessor :end_segment_number
    attr_accessor :uri

    def initialize(manifest_id, hash = {})
      hsh = ActiveSupport::HashWithIndifferentAccess.new(underscore_hash(hash))
      @manifest_id = manifest_id
      self.class.init(File.join("/v1/encoding/manifests/hls/", manifest_id, "media/audio"))
      super(hsh)
    end

    def ignore_fields
      return [:@manifest_id, :@id]
    end

  end
end
