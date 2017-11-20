module Bitmovin::Encoding
  module Inputs
    def Inputs.list(limit = 100, offset = 0)
      response = Bitmovin.client.get '/v1/encoding/inputs', { limit: limit, offset: offset }
      result = (JSON.parse(response.body))['data']['result']
      list = result['items'].map do |item|
        case item['type'].downcase
        when "s3"
          S3Input.new(item)
        when "gcs"
          GcsInput.new(item)
        when "http"
          HttpInput.new(item)
        when "https"
          HttpsInput.new(item)
        when "aspera"
          AsperaInput.new(item)
        when "rtmp"
          RtmpInput.new(item)
        when "generic-s3"
          GenericS3Input.new(item)
        when "azure"
          AzureInput.new(item)
        when "ftp"
          FtpInput.new(item)
        when "sftp"
          SftpInput.new(item)
        end
      end
      list
    end
  end
end
require 'bitmovin/encoding/inputs/s3_input'
require 'bitmovin/encoding/inputs/rtmp_input'
require 'bitmovin/encoding/inputs/generic_s3_input'
require 'bitmovin/encoding/inputs/gcs_input'
require 'bitmovin/encoding/inputs/azure_input'
require 'bitmovin/encoding/inputs/ftp_input'
require 'bitmovin/encoding/inputs/sftp_input'
require 'bitmovin/encoding/inputs/http_input'
require 'bitmovin/encoding/inputs/https_input'
require 'bitmovin/encoding/inputs/aspera_input'
require 'bitmovin/encoding/inputs/analysis'
require 'bitmovin/encoding/inputs/analysis_task'
