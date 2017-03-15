module Bitmovin::Encoding::CodecConfigurations
  class H264Configuration < Bitmovin::ConfigurationResource
    init 'encoding/configurations/video/h264'

    attr_accessor :id, :created_at, :modified_at, :name, :description
    attr_accessor :width, :height, :bitrate, :rate, :profile, :bframes, :ref_frames, :qp_min, :qp_max, :mv_prediction_mode, :mv_search_range_max, :cabac, :max_bitrate, :min_bitrate, :bufsize
    attr_accessor :min_gop, :max_gop, :level, :b_adaptive_strategy, :motion_estimation_method, :rc_look_ahead, :sub_me, :trellis, :partitions, :slices, :interlace_mode
  end
end
