# CONFIGURATION
BITMOVIN_API_KEY = 'YOUR API KEY HERE'

HTTP_INPUT_HOST = 'your.host.com'
HTTP_INPUT_FILE_PATH = '/path/to/your/input/file.mkv'

OUTPUT_AWS_ACCESS_KEY = 'YOUR AWS_ACCESS_KEY'
OUTPUT_AWS_SECRET_KEY = 'YOUR AWS_SECRET_KEY'

BUCKET_NAME = 'YOUR BUCKET NAME HERE'
OUTPUT_PATH = 'path/to/output'
MPD_NAME = 'manifest.mpd'

# Please refer to our API spec to get available cloud regions
# https://bitmovin.com/encoding-documentation/bitmovin-api/#/reference/encoding/encodings/create-encoding
ENCODING_CLOUD_REGION = 'GOOGLE_EUROPE_WEST_1'

Bitmovin.init(BITMOVIN_API_KEY)

# This will create a http input
# To get a list of all your HTTP outputs do:
# Bitmovin::Encoding::Outputs::HttpOutput.list
http_input = Bitmovin::Encoding::Inputs::HttpInput.new({
                                                           host: HTTP_INPUT_HOST
                                                       }).save!

# For reuse set http_input_id = '<YOUR HTTP INPUT ID>' and omit creation
http_input_id = http_input.id

# This will create a Output Bucket you can reuse in future encodings
# To get a list of all your Output do:
# Bitmovin::Encoding::Outputs::S3Output.list
s3_output = Bitmovin::Encoding::Outputs::S3Output.new({
                                                          accessKey: OUTPUT_AWS_ACCESS_KEY,
                                                          secretKey: OUTPUT_AWS_SECRET_KEY,
                                                          bucketName: BUCKET_NAME
                                                      }).save!

# For reuse set s3_output_id = '<YOUR S3 OUTPUT ID>' and omit creation
s3_output_id = s3_output.id

# Codec Configurations are similar to Inputs/Outputs in that they are configured once
# and can be reused for future encodings.
codec_config_720_700 = Bitmovin::Encoding::CodecConfigurations::H264Configuration.new({
                                                                                          name: 'H264 1280x720 700kb/s',
                                                                                          profile: 'MAIN',
                                                                                          width: 1280,
                                                                                          height: 720,
                                                                                          bitrate: 700000
                                                                                      })
codec_config_720_700.save!
codec_config_720_1500 = Bitmovin::Encoding::CodecConfigurations::H264Configuration.new({
                                                                                           name: 'H264 1280x720 1500kb/s',
                                                                                           profile: 'MAIN',
                                                                                           width: 1280,
                                                                                           height: 720,
                                                                                           bitrate: 1500000
                                                                                       })
codec_config_720_1500.save!
codec_config_720_2400 = Bitmovin::Encoding::CodecConfigurations::H264Configuration.new({
                                                                                           name: 'H264 1280x720 2400kb/s',
                                                                                           profile: 'MAIN',
                                                                                           width: 1280,
                                                                                           height: 720,
                                                                                           bitrate: 2400000
                                                                                       })
codec_config_720_2400.save!

audio_config = Bitmovin::Encoding::CodecConfigurations::AacConfiguration.new({
                                                                                 name: 'AAC_PROFILE_128k',
                                                                                 bitrate: 128000,
                                                                                 rate: 48000
                                                                             })
audio_config.save!


# The actual instance of the encoding task you are about to start
enc = Bitmovin::Encoding::Encodings::EncodingTask.new({
                                                          name: 'VOD Encoding Ruby',
                                                          cloud_region: ENCODING_CLOUD_REGION
                                                      })
enc.save!

# Stream Configuration

stream_720_700 = enc.streams.build(name: 'H264 1280x720 700kb/s')
stream_720_700.codec_configuration = codec_config_720_700
stream_720_700.build_input_stream(input_path: INPUT_FILE_PATH, input_id: http_input_id, selection_mode: 'AUTO')
stream_720_700.save!

stream_720_1500 = enc.streams.build(name: 'H264 1280x720 1500/s')
stream_720_1500.codec_configuration = codec_config_720_1500
stream_720_1500.build_input_stream(input_path: INPUT_FILE_PATH, input_id: http_input_id, selection_mode: 'AUTO')
stream_720_1500.save!

stream_720_2400 = enc.streams.build(name: 'H264 1280x720 2400/s')
stream_720_2400.codec_configuration = codec_config_720_2400
stream_720_2400.build_input_stream(input_path: INPUT_FILE_PATH, input_id: http_input_id, selection_mode: 'AUTO')
stream_720_2400.save!

stream_aac = enc.streams.build(name: 'audio stream')
stream_aac.codec_configuration = audio_config
stream_aac.build_input_stream(input_path: INPUT_FILE_PATH, input_id: http_input_id, selection_mode: 'AUTO')
stream_aac.save!

# Muxing Configuration

fmp4_muxing_720_700 = enc.muxings.fmp4.build(name: 'H264 1280x720 700kb/s', segment_length: 4)
fmp4_muxing_720_700.build_output({
                                     output_id: s3_output_id,
                                     output_path: File.join(OUTPUT_PATH, 'video/720_700')
                                 })
fmp4_muxing_720_700.streams << stream_720_700.id
fmp4_muxing_720_700.save!

fmp4_muxing_720_1500 = enc.muxings.fmp4.build(name: 'H264 1280x720 1500kb/s', segment_length: 4)
fmp4_muxing_720_1500.build_output({
                                      output_id: s3_output_id,
                                      output_path: File.join(OUTPUT_PATH, 'video/720_1500')
                                  })
fmp4_muxing_720_1500.streams << stream_720_1500.id
fmp4_muxing_720_1500.save!

fmp4_muxing_720_2400 = enc.muxings.fmp4.build(name: 'H264 1280x720 2400kb/s', segment_length: 4)
fmp4_muxing_720_2400.build_output({
                                      output_id: s3_output_id,
                                      output_path: File.join(OUTPUT_PATH, 'video/720_2400')
                                  })
fmp4_muxing_720_2400.streams << stream_720_2400.id
fmp4_muxing_720_2400.save!

audio_muxing = enc.muxings.fmp4.build(name: 'audio-muxing', segment_length: 4)
audio_muxing.build_output({
                              output_id: s3_output_id,
                              output_path: File.join(OUTPUT_PATH, 'audio/aac')
                          })
audio_muxing.streams << stream_aac.id
audio_muxing.save!


# Starting an encoding and monitoring it's status
enc.start!

while enc.status != 'FINISHED' && enc.status != 'ERROR'
  puts "Encoding Status is #{enc.status}"
  progress = enc.progress
  if progress > 0
    puts "Progress: #{enc.progress} %"
  end
  sleep 2
end
puts "Encoding finished with status #{enc.status}!"


# Generating a DASH Manifest
puts 'Starting Manifest generation'
manifest = Bitmovin::Encoding::Manifests::DashManifest.new({
                                                               name: 'Test Ruby Manifest',
                                                               description: 'Test encoding with ruby',
                                                               manifest_name: MPD_NAME
                                                           })

manifest.outputs << Bitmovin::Encoding::StreamOutput.new({
                                                             output_id: s3_output_id,
                                                             output_path: OUTPUT_PATH
                                                         })
manifest.save!

period = manifest.build_period()
period.save!

video_adaptationset = period.build_video_adaptationset()
video_adaptationset.save!

audio_adaptationset = period.build_audio_adaptationset({lang: 'en'})
audio_adaptationset.save!

video_adaptationset.build_fmp4_representation({
                                                  encoding_id: enc.id,
                                                  muxing_id: fmp4_muxing_720_2400.id,
                                                  type: 'TEMPLATE',
                                                  segment_path: 'video/720_2400'
                                              }).save!
video_adaptationset.build_fmp4_representation({
                                                  encoding_id: enc.id,
                                                  muxing_id: fmp4_muxing_720_1500.id,
                                                  type: 'TEMPLATE',
                                                  segment_path: 'video/720_1500'
                                              }).save!
video_adaptationset.build_fmp4_representation({
                                                  encoding_id: enc.id,
                                                  muxing_id: fmp4_muxing_720_700.id,
                                                  type: 'TEMPLATE',
                                                  segment_path: 'video/720_700'
                                              }).save!

audio_adaptationset.build_fmp4_representation({
                                                  encoding_id: enc.id,
                                                  muxing_id: audio_muxing.id,
                                                  name: 'Audio representation',
                                                  type: 'TEMPLATE',
                                                  segment_path: 'audio/aac'
                                              }).save!

manifest.start!

while manifest.status != 'FINISHED' && manifest.status != 'ERROR'
  puts "Manifest Status is #{manifest.status}"
  progress = manifest.progress
  if progress > 0
    puts "Progress: #{manifest.progress} %"
  end
  sleep 2
end

puts "Manifest generation finished with status #{manifest.status}!"
