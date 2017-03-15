module Bitmovin::Encoding::CodecConfigurations
  class AacConfiguration < Bitmovin::ConfigurationResource
    init 'encoding/configurations/audio/aac'
    attr_accessor :id, :name, :description, :created_at, :modified_at
    attr_accessor :bitrate, :rate, :channel_layout, :volume_adjust, :normalize
  end
end
