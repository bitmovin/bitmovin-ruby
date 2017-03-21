module Bitmovin::Encoding::Manifests
  class DashAdaptationset
    def initialize(manifest_id)
      @manifest_id = manifest_id
      @video = []
      @audio = []
    end

    attr_accessor :manifest_id
    attr_accessor :video
    attr_accessor :audio

    def build_video_adaptation(hash = {})
      adaptation = VideoAdaptation.new(manifest_id)
      @video << adaptation
      adaptation
    end
    def build_audio_adaptation(hash = {})
    end
  end
end
