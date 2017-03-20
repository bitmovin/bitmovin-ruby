module Bitmovin::Encoding::Encodings::Muxings
  class TsMuxingList < Bitmovin::Encoding::Encodings::List
    init "muxings/ts", Bitmovin::Encoding::Encodings::Muxings::TsMuxing
  end
end
