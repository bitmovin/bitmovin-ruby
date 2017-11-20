module Bitmovin::Encoding::Manifests
  class HlsAudioMedia < Bitmovin::Resource
    attr_accessor :manifest_id
    attr_accessor :groupId
    attr_accessor :language
    attr_accessor :assocLanguage
    attr_accessor :name
    attr_accessor :isDefault
    attr_accessor :autoselect
    attr_accessor :characteristics
    attr_accessor :segmentPath
    attr_accessor :encodingId
    attr_accessor :streamId
    attr_accessor :muxingId
    attr_accessor :drmId
    attr_accessor :startSegmentNumber
    attr_accessor :endSegmentNumber
    attr_accessor :uri

    def initialize(manifest_id, hash = {})
      hsh = ActiveSupport::HashWithIndifferentAccess.new(underscore_hash(hash))
      @manifest_id = manifest_id
      self.class.init(File.join("/v1/encoding/manifests/hls/", manifest_id, "media/audio"))
      super(hsh)
    end
  end
end
