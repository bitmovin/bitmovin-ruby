module Bitmovin::Encoding::Encodings::Drms
    class CencDrm < Fmp4DrmResource
      attr_accessor :widevine, :play_ready
    end
  end