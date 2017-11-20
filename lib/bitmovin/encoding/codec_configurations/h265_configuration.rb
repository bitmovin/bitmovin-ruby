module Bitmovin::Encoding::CodecConfigurations
  class H265Configuration < Bitmovin::ConfigurationResource
    init 'encoding/configurations/video/h265'

  attr_accessor :id, :name, :description, :created_at, :modified_at
  attr_accessor :width, :height
  attr_accessor :name, :description, :bitrate, :rate, :profile, :bframes, :ref_frames, :qp, :max_bitrate, :min_bitrate, :bufsize, :min_gop, :max_gop, :level, :rc_lookahead, :b_adapt, :max_ctu_size, :tu_intra_depth, :tu_inter_depth, :motion_search, :sub_me, :motion_search_range, :weight_prediction_on_p_slice, :weight_prediction_on_b_slice, :sao
  end
end
