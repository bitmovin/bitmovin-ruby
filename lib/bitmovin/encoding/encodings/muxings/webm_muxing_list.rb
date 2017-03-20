module Bitmovin::Encoding::Encodings::Muxings
  class WebmMuxingList < Bitmovin::Encoding::Encodings::List
    init "webm", Bitmovin::Encoding::Encodings::Muxings::TsMuxing
  end
end
