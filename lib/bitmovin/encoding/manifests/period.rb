module Bitmovin::Encoding::Manifests
  class Period < Bitmovin::Resource
    def initialize(manifest_id, hash = {})
      self.class.init(File.join("/v1/encoding/manifests/dash/", manifest_id, "periods"))
      @manifest_id = manifest_id
      super(hash)
    end
    attr_accessor :manifest_id, :duration, :start
  end
end
