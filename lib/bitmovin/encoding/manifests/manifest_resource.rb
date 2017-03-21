module Bitmovin::Encoding::Manifests
  class ManifestResource < Bitmovin::Resource
    def initialize(hash = {})
      hsh = ActiveSupport::HashWithIndifferentAccess.new(underscore_hash(hash))
      muxing_type = self.class.name.demodulize.gsub(/(.*)Muxing/, '\1').downcase
      self.class.init(File.join("/v1/encoding/manifests/", encoding_id, "muxings", muxing_type))
      super(hsh)
      @outputs = (hsh[:outputs] || []).map do |output|
        Bitmovin::Encoding::Encodings::StreamOutput.new(encoding_id, @id, output)
      end
      @streams = (hsh[:streams] || []).map do |stream|
        stream[:stream_id]
      end
    end
  end
end
