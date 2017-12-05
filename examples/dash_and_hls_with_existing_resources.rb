require 'securerandom'
require 'bitmovin-ruby'

BITMOVIN_API_KEY = '<INSERT YOUR API KEY>'
Bitmovin.init(BITMOVIN_API_KEY)

ENCODING_CLOUD_REGION = 'GOOGLE_EUROPE_WEST_1'
INPUT_FILE_PATH = '/pub/graphics/blender/demo/movies/Sintel.2010.1080p.mkv'
OUTPUT_PATH = "output/bitmovin-ruby/#{Time.now.strftime('%v-%H-%M')}/".gsub!(/\s+/, '')
MPD_NAME = 'myTest.mpd'
M3U8_NAME = 'myTest.m3u8'

input_to_use = Bitmovin::Encoding::Inputs::HttpInput.find('<INSERT YOUR INPUT ID HERE>')
output_to_use = Bitmovin::Encoding::Outputs::S3Output.find('<INSERT YOUR OUTPUT ID HERE>')

# This could be selected, maybe with an web interface
aac_codec_config_ids_to_use = ['<INSERT YOUR AAC CODEC CONFIG ID HERE>']
h264_codec_config_ids_to_use = %w(<INSERT YOUR H264 CODEC CONFIG ID HERE> <INSERT ANOTHER H264 CODEC CONFIG ID HERE> <AND A THIRD H264 CODEC CONFIG ID>)

aac_codec_configs = Bitmovin::Encoding::CodecConfigurations::AacConfiguration.list(100, 0)
h264_codec_configs = Bitmovin::Encoding::CodecConfigurations::H264Configuration.list(100, 0)

# The actual instance of the encoding task you are about to start
enc = Bitmovin::Encoding::Encodings::EncodingTask.new({
                                                          name: 'VOD Encoding Ruby',
                                                          cloud_region: ENCODING_CLOUD_REGION
                                                      })
enc.save!

# This method checks if the selected id is in the list retrieved from API
# Could be extended to throw an error if it is not found
def find_resources_to_use(resources, resource_ids_to_use)
  result_array = []
  resources.each do |resource|
    if resource_ids_to_use.include? resource.id
      result_array.push(resource)
    end
  end
  result_array
end

h264_codec_configs_to_use = find_resources_to_use(h264_codec_configs, h264_codec_config_ids_to_use)
aac_codec_configs_to_use = find_resources_to_use(aac_codec_configs, aac_codec_config_ids_to_use)

# DASH manifest generation
dash_manifest = Bitmovin::Encoding::Manifests::DashManifest.new({
                                                                    name: 'Test Ruby Manifest',
                                                                    description: 'Test encoding with ruby',
                                                                    manifest_name: MPD_NAME
                                                                })

dash_manifest.outputs << Bitmovin::Encoding::StreamOutput.new({
                                                                  output_id: output_to_use.id,
                                                                  output_path: OUTPUT_PATH
                                                              })
dash_manifest.save!

period = dash_manifest.build_period()
period.save!

video_adaptationset = period.build_video_adaptationset()
video_adaptationset.save!

audio_adaptationset = period.build_audio_adaptationset({lang: 'en'})
audio_adaptationset.save!

# HLS manifest generation
hls_manifest = Bitmovin::Encoding::Manifests::HlsManifest.new({
                                                                  name: 'Test Ruby Manifest',
                                                                  description: 'Test encoding with ruby',
                                                                  manifest_name: M3U8_NAME
                                                              })

hls_manifest.outputs << Bitmovin::Encoding::StreamOutput.new({
                                                                 output_id: output_to_use.id,
                                                                 output_path: OUTPUT_PATH
                                                             })
hls_manifest.save!

aac_codec_configs_to_use.each do |aac_config|
  # Stream Configuration
  stream_aac = enc.streams.build(name: 'Audio Stream')
  stream_aac.codec_configuration = aac_config
  stream_aac.build_input_stream(input_path: INPUT_FILE_PATH,
                                input_id: input_to_use.id,
                                selection_mode: 'AUTO')
  stream_aac.save!

  # Create unique segment path
  unique_name = "#{aac_config.bitrate}_#{SecureRandom.hex(4)}"
  fmp4_segment_path = "audio/fmp4/#{unique_name}"
  ts_segment_path = "audio/ts/#{unique_name}"

  # Muxing Configuration
  # FMP4
  fmp4_muxing = enc.muxings.fmp4.build(name: "#{unique_name} muxing", segment_length: 4)
  fmp4_muxing.build_output({
                               output_id: output_to_use.id,
                               output_path: File.join(OUTPUT_PATH, fmp4_segment_path),
                               acl: [{
                                         permission: 'PUBLIC_READ'
                                     }]
                           })
  fmp4_muxing.streams << stream_aac.id
  fmp4_muxing.save!

  # TS
  ts_muxing = enc.muxings.ts.build(name: "#{unique_name} muxing", segment_length: 4)
  ts_muxing.build_output({
                             output_id: output_to_use.id,
                             output_path: File.join(OUTPUT_PATH, ts_segment_path),
                             acl: [{
                                       permission: 'PUBLIC_READ'
                                   }]
                         })
  ts_muxing.streams << stream_aac.id
  ts_muxing.save!

  # Add representation to dash manifest
  audio_adaptationset.build_fmp4_representation({
                                                    encoding_id: enc.id,
                                                    muxing_id: fmp4_muxing.id,
                                                    type: 'TEMPLATE',
                                                    segment_path: fmp4_segment_path
                                                }).save!

  # Add media stream to hls playlist
  audio_stream_medium = hls_manifest.build_audio_medium({
                                                            name: 'HLS Audio Media',
                                                            group_id: 'audio_group',
                                                            segment_path: ts_segment_path,
                                                            encoding_id: enc.id,
                                                            stream_id: stream_aac.id,
                                                            muxing_id: ts_muxing.id,
                                                            language: 'en',
                                                            uri: "#{unique_name}.m3u8"
                                                        })
  audio_stream_medium.save!
end

h264_codec_configs_to_use.each do |h264_config|
# Stream Configuration
  stream_h264 = enc.streams.build(name: 'Video Stream')
  stream_h264.codec_configuration = h264_config
  stream_h264.build_input_stream(input_path: INPUT_FILE_PATH,
                                 input_id: input_to_use.id,
                                 selection_mode: 'AUTO')
  stream_h264.save!

  # Create unique segment path
  unique_name = "#{h264_config.bitrate}_#{SecureRandom.hex(4)}"
  fmp4_segment_path = "video/fmp4/#{unique_name}"
  ts_segment_path = "video/ts/#{unique_name}"

  # Muxing Configuration
  # FMP4
  fmp4_muxing = enc.muxings.fmp4.build(name: "#{unique_name} muxing", segment_length: 4)
  fmp4_muxing.build_output({
                               output_id: output_to_use.id,
                               output_path: File.join(OUTPUT_PATH, fmp4_segment_path),
                               acl: [{
                                         permission: 'PUBLIC_READ'
                                     }]
                           })
  fmp4_muxing.streams << stream_h264.id
  fmp4_muxing.save!

  # TS
  ts_muxing = enc.muxings.ts.build(name: "#{unique_name} muxing", segment_length: 4)
  ts_muxing.build_output({
                             output_id: output_to_use.id,
                             output_path: File.join(OUTPUT_PATH, ts_segment_path),
                             acl: [{
                                       permission: 'PUBLIC_READ'
                                   }]
                         })
  ts_muxing.streams << stream_h264.id
  ts_muxing.save!

  # Add representation to dash manifest
  video_adaptationset.build_fmp4_representation({
                                                    encoding_id: enc.id,
                                                    muxing_id: fmp4_muxing.id,
                                                    type: 'TEMPLATE',
                                                    segment_path: fmp4_segment_path
                                                }).save!

  # Add media stream to hls playlist
  hls_manifest.build_stream({
                                audio: 'audio_group',
                                closed_captions: 'NONE',
                                segmentPath: ts_segment_path,
                                encoding_id: enc.id,
                                muxing_id: ts_muxing.id,
                                stream_id: stream_h264.id,
                                uri: "#{unique_name}.m3u8"
                            }).save!
end

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

# Start DASH manifest generation
dash_manifest.start!
while dash_manifest.status != 'FINISHED' && dash_manifest.status != 'ERROR'
  puts "DASH Manifest Status is #{dash_manifest.status}"
  progress = dash_manifest.progress
  if progress > 0
    puts "DASH Manifest Progress: #{dash_manifest.progress} %"
  end
  sleep 2
end
puts "DASH Manifest generation finished with status #{dash_manifest.status}!"

# Start HLS manifest generation
hls_manifest.start!
while hls_manifest.status != 'FINISHED' && hls_manifest.status != 'ERROR'
  puts "HLS Manifest Status is #{hls_manifest.status}"
  progress = hls_manifest.progress
  if progress > 0
    puts "HLS Manifest Progress: #{hls_manifest.progress} %"
  end
  sleep 2
end

puts "HLS Manifest generation finished with status #{hls_manifest.status}!"
