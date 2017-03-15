module Bitmovin::Encoding::CodecConfigurations
  class Vp9Configuration < Bitmovin::ConfigurationResource
    init 'encoding/configurations/video/vp9'

    attr_accessor :id, :name, :description, :created_at, :modified_at
    attr_accessor :bitrate, :rate, :tile_columns, :tile_rows, :frame_parallel, :max_intra_rate, :qp_min, :qp_max, :rate_undershoot_pct, :rate_overshoot_pct, :cpu_used, :quality, :lossless, :aq_mode, :arnr_max_frames, :arnr_strength, :arnr_type
  end
end
