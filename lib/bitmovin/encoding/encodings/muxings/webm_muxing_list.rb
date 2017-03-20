module Bitmovin::Encoding::Encodings::Muxings
  class WebmMuxingList < Bitmovin::Encoding::Encodings::List
    init "muxings/webm", Bitmovin::Encoding::Encodings::Muxings::WebmMuxing
  end
end
