module Bitmovin::Encoding::Manifests
  class Period < Bitmovin::Resource
    include Bitmovin::ChildCollection

    def initialize(manifest_id, hash = {})
      self.class.init(File.join("/v1/encoding/manifests/dash/", manifest_id, "periods"))
      @manifest_id = manifest_id
      super(hash)
      @video_adaptationsets = nil
      @audio_adaptationsets = nil
    end
    attr_accessor :manifest_id, :duration, :start

    child_collection(:video_adaptationsets, "/v1/encoding/manifests/dash/%s/periods/%s/adaptationsets/video", [:manifest_id, :id], VideoAdaptationSet)
    child_collection(:audio_adaptationsets, "/v1/encoding/manifests/dash/%s/periods/%s/adaptationsets/audio", [:manifest_id, :id], AudioAdaptationSet)

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
