module Bitmovin::Encoding::Manifests
  class HlsManifest < Bitmovin::Resource
    init("/v1/encoding/manifests/hls")

    attr_accessor :outputs, :manifest_name
  end
end
