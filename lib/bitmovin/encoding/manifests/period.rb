module Bitmovin::Encoding::Manifests
  class Period < Bitmovin::Resource
    def initialize(manifest_id, hash = {})
      self.class.init(File.join("/v1/encoding/manifests/dash/", manifest_id, "periods"))
      @manifest_id = manifest_id
      super(hash)
      @video_adaptationsets = nil
      @audio_adaptationsets = nil
    end
    attr_accessor :manifest_id, :duration, :start

    def video_adaptationsets
      if @video_adaptationsets.nil?
        @video_adaptationsets = load_video_adaptationsets
      end
      @video_adaptationsets
    end

    def audio_adaptationsets
      if @audio_adaptationsets.nil?
        @audio_adaptationsets = load_audio_adaptationsets
      end
      @audio_adaptationsets
    end

    private
    def load_video_adaptationsets
      path = File.join("/v1/encoding/manifests/dash/", @manifest_id, "periods", @id, "adaptationsets/video")
      response = Bitmovin.client.get(path)
      result(response)["items"].map { |item| VideoAdaptationSet.new(@manifest_id, @id, item) }
    end

    def load_audio_adaptationsets
      path = File.join("/v1/encoding/manifests/dash/", @manifest_id, "periods", @id, "adaptationsets/audio")
      response = Bitmovin.client.get(path)
      result(response)["items"].map { |item| AudioAdaptationSet.new(@manifest_id, @id, item) }
    end
  end
end
