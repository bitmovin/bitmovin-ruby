module Bitmovin::Encoding::Inputs
  class Analysis
    # Creates a new Analysis object
    # == Parameters:
    # input::
    #   Either an input-id (string) or a InputResource
    # analysis_id::
    #   Id of the analysis task
    def initialize(input, analysis_id)
      if (input.instance_of?(String))
        @input_id = input
      else
        @input_id = input.id
        @input = input
      end
      @id = analysis_id
    end

    attr_reader :id, :input_id

    def input
      @input
    end
  end
end
