module Bitmovin::Encoding::CodecConfigurations
  class Vp9Configuration < Bitmovin::ConfigurationResource
    init 'encoding/configurations/video/vp9'

    attr_accessor :id, :name, :description, :created_at, :modified_at
    attr_accessor :bitrate, :rate, :tileColumns, :tileRows, :frameParallel, :maxIntraRate, :qpMin, :qpMax, :rateUndershootPct, :rateOvershootPct, :cpuUsed, :quality, :lossless, :aqMode, :arnrMaxFrames, :arnrStrength, :arnrType
  end
end
