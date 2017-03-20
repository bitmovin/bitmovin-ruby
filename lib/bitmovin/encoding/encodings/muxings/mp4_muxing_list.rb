module Bitmovin::Encoding::Encodings::Muxings
  class Mp4MuxingList < Bitmovin::Encoding::Encodings::List
    init "mp4", Bitmovin::Encoding::Encodings::Muxings::TsMuxing
  end
end
