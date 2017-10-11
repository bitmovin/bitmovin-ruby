module Bitmovin::Encoding::Manifests
  class HlsManifest < Bitmovin::Resource
    init("/v1/encoding/manifests/hls")

    attr_accessor :outputs, :manifest_name

    def initialize(hash = {})
      hsh = ActiveSupport::HashWithIndifferentAccess.new(underscore_hash(hash))
      super(hash)
      @outputs = (hsh[:outputs] || []).map { |output| Bitmovin::Encoding::StreamOutput.new(output) }
    end

    def streams
      if !persisted?
        raise BitmovinError.new(self), "Needs to be persisted first"
      end
      HlsVariantStreamList.new(@id)
    end
  end
end
