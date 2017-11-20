module Bitmovin::Encoding::Manifests
  class HlsVariantStreamList < Bitmovin::Resource
    init "streams"
    attr_accessor :manifest_id

    def initialize(manifest_id)
      @manifest_id = manifest_id
      self.class.init(File.join("/v1/encoding/manifests/", manifest_id, "streams"))
      #super(hsh)
    end

    def list(limit = 100, offset = 0)
      path = File.join("/v1/encoding/manifests/hls", @manifest_id, self.class.resource_path)
      response = Bitmovin.client.get(path, { limit: limit, offset: offset })
      result(response)['items'].map { |item| self.class.klass.new(@manifest_id, item) }
    end

    def build(hash = {})
      HlsVariantStream.new(@manifest_id, hash)
    end
  end
end
