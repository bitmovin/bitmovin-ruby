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
      path = File.join("/v1/encoding/manifests/dash/", @manifest_id, "periods", @id, "adaptationsets/video")
      response = Bitmovin.client.get(path)
      result(response)["items"].map { |item| VideoAdaptationSet.new(@manifest_id, @id, item) }
    end

    def audio_adaptationsets
    end
  end
end
