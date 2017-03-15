module Bitmovin::Encoding::Inputs
  class AnalysisTask
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

    def status
      five_seconds_ago = (Time.now - 5)
      puts @last_status_call
      if @last_status_call.nil? || @last_status_call <= five_seconds_ago
        response = Bitmovin.client.get File.join("/v1/encoding/inputs/", @input_id, "analysis", @id, "status")
        @status_result = OpenStruct.new(JSON.parse(response.body)['data']['result']['analysis'])
        @last_status_call = Time.now
      end
      @status_result
    end

    def created?
      status.status == "CREATED"
    end

    def queued?
      status.status == "QUEUED"
    end

    def running?
      status.status == "RUNNING"
    end

    def finished?
      status.status == "FINISHED"
    end

    def error?
      status.status == "ERROR"
    end

    def eta?
      status.eta
    end

    def progress?
      status.progress
    end

    # Returns the analysis result
    # Will raise and error if analysis is not yet finished
    def result
      if !finished?
        raise BitmovinError.new(self), "analysis is not finished yet"
      end
      Analysis.new(@input_id).find(@id)
    end
  end
end
