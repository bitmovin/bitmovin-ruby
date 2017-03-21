module Bitmovin::Encoding::Manifests
  class Period < Bitmovin::Resource
    def initialize(manifest_id, hash = {})
      @manifest_id = manifest_id
      @resource_path = File.join("/v1/encoding/manifests/dash/", manifest_id, "periods")
    end
    attr_accessor :manifest_id, :duration, :start
  end
end
