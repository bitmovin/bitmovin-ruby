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
      if !persisted?
        raise "Period is not persisted yet - can't create video adaptationset"
      end
      if @video_adaptationsets.nil?
        @video_adaptationsets = load_video_adaptationsets
      end
      @video_adaptationsets
    end

    def audio_adaptationsets
      if !persisted?
        raise "Period is not persisted yet - can't create audio adaptationset"
      end
      if @audio_adaptationsets.nil?
        @audio_adaptationsets = load_audio_adaptationsets
      end
      @audio_adaptationsets
    end

    def build_video_adaptationset(hash = {})
      if !persisted?
        raise "Period is not persisted yet - can't create video adaptationset"
      end
      VideoAdaptationSet.new(@manifest_id, @id, hash)
    end

    def build_audio_adaptationset(hash = {})
      if !persisted?
        raise "Period is not persisted yet - can't create audio adaptationset"
      end
      AudioAdaptationSet.new(@manifest_id, @id, hash)
    end

    def persisted?
      !@id.nil?
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
