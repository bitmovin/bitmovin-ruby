module Bitmovin::Encoding::Inputs
  class RtmpInput < Bitmovin::Resource
    init 'encoding/inputs/rtmp'
    attr_accessor :id, :created_at, :modified_at, :name, :description
  end
end
