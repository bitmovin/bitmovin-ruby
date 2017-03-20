module Bitmovin::Encoding::Encodings
  class MuxingList
    include Bitmovin::Helpers

    attr_accessor :encoding_id

    def initialize(encoding_id)
      @encoding_id = encoding_id
    end

    [:fmp4, :webm, :mp4, :ts].each do |muxing_type|
      define_method "#{muxing_type}" do
        klass = "Bitmovin::Encoding::Encodings::Muxings::#{muxing_type.to_s.camelize}MuxingList".constantize
        klass.new(@encoding_id)
      end
    end

  end
end
