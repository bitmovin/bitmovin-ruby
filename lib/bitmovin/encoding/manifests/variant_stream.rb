module Bitmovin::Encoding::Manifests
    class VariantStream < Bitmovin::Resource
      def initialize(manifest_id, hash = {})
        path = File.join("/v1/encoding/manifests/hls/", manifest_id, "streams")
        self.class.init(path)
        super(hash)
        @manifest_id = manifest_id
      end
  
      attr_accessor :manifest_id
  
      attr_accessor :audio, :video, :subtitles, :closed_captions
      attr_accessor :segment_path, :uri, :encoding_id, :stream_id, :muxing_id
      attr_accessor :start_segment_number, :end_segment_number
    end
end
  