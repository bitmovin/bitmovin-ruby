module Bitmovin::Encoding::Encodings::Muxings
  class MuxingResource < Bitmovin::Resource
    attr_accessor :encoding_id
    attr_accessor :id

    def initialize(encoding_id, hash = {})
      hsh = ActiveSupport::HashWithIndifferentAccess.new(underscore_hash(hash))
      @encoding_id = encoding_id
      muxing_type = self.class.name.demodulize.gsub(/(.*)Muxing/, '\1').downcase
      self.class.init(File.join("/v1/encoding/encodings/", encoding_id, "muxings", muxing_type))
      super(hsh)
      @outputs = (hsh[:outputs] || []).map do |output|
        Bitmovin::Encoding::Encodings::StreamOutput.new(encoding_id, @id, output)
      end
      @streams = (hsh[:streams] || []).map do |stream|
        stream[:stream_id]
      end
    end

    attr_accessor :streams, :outputs, :stream_ids
  end
end
