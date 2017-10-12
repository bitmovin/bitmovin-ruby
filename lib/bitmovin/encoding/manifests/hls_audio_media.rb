module Bitmovin::Encoding::Manifests
  class HlsAudioMedia < Bitmovin::Resource
    def initialize(manifest_id, hash = {})
      hsh = ActiveSupport::HashWithIndifferentAccess.new(underscore_hash(hash))
      @manifest_id = manifest_id
      self.class.init(File.join("/v1/encoding/manifests/", manifest_id, "audio/media"))
      super(hsh)
    end
  end
end
