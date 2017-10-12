module Bitmovin::Encoding
  module Manifests
    def self.list(*args)
      # TODO
    end

    def self.dash
      # TODO
    end

    def self.hls
      # TODO
    end
  end
end

require 'bitmovin/encoding/manifests/fmp4_representation'
require 'bitmovin/encoding/manifests/audio_adaptation_set'
require 'bitmovin/encoding/manifests/video_adaptation_set'
require 'bitmovin/encoding/manifests/period'
require 'bitmovin/encoding/manifests/dash_manifest'
require 'bitmovin/encoding/manifests/hls_audio_media'
require 'bitmovin/encoding/manifests/hls_variant_stream'
require 'bitmovin/encoding/manifests/hls_manifest'
require 'bitmovin/encoding/manifests/dash_representations'
require 'bitmovin/encoding/manifests/hls_variant_stream_list'
