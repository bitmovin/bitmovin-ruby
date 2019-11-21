module Bitmovin::Encoding::Encodings
  module InputStreams
    module Trimming
      class TimeBased < Bitmovin::Resource
        attr_accessor :encoding_id, :input_stream_id, :offset, :duration,
          :name, :description, :created_at, :modified_at, :errors

        def initialize(encoding_id, hash = {})
          hsh = ActiveSupport::HashWithIndifferentAccess.new(underscore_hash(hash))
          @encoding_id = encoding_id

          init_instance(File.join("/v1/encoding/encodings/", encoding_id, "input-streams/trimming/time-based"))
          super(hash)

          @offset = hash[:offset]
          @duration = hash[:duration]
          @input_stream_id = hash[:input_stream_id]

          @errors = []
        end

        def save!
          super if valid?
        end

        def invalid?
          !valid?
        end

        def valid?
          validate!
          @errors.empty?
        end

        def validate!
          @errors = []

          @errors << "Input Stream Id must be set" unless @input_stream_id
          @errors << "Offset must be set" unless @offset
          @errors << "Duration must be set" unless @duration
          @errors << "Duration must be greater than zero" if @duration.to_i <= 0

          @errors.flatten!
        end
      end
    end
  end
end
