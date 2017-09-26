module Bitmovin::Encoding::Manifests
    class VideoMedia < Bitmovin::Resource
      def initialize(manifest_id, hash = {})
        path = File.join("/v1/encoding/manifests/hls/", manifest_id, "media/video")
        self.class.init(path)
        super(hash)
        @manifest_id = manifest_id
      end
  
      attr_accessor :manifest_id
  
      attr_accessor :groupId, :language, :assoc_language, :name, :is_default
      attr_accessor :autoselect, :characteristics, :segment_path, :encoding_id
      attr_accessor :stream_id, :muxing_id, :drm_id, :start_segment_number
      attr_accessor :end_segment_number, :uri
    end
end
  