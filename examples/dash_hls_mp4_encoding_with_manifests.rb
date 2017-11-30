require 'bitmovin-ruby'

# CONFIGURATION
BITMOVIN_API_KEY = 'YOUR API KEY HERE'

S3_INPUT_ID = 'The ID of the Input'
S3_OUTPUT_ID = 'The ID of the Output'
OUTPUT_PATH = "/encoding_test/bitmovin-ruby/#{Time.now.strftime('%v-%H-%M')}/"
INPUT_FILE_PATH = 'your_input_file_name'

Bitmovin.init(BITMOVIN_API_KEY)

# This will create a Input Bucket you can reuse in future encodings
# To get a list of all your S3Inputs do:
# Bitmovin::Encoding::Inputs::S3Input.list
s3_input = Bitmovin::Encoding::Inputs::S3Input.find(S3_INPUT_ID)

# This will create a Output Bucket you can reuse in future encodings
# To get a list of all your Output do:
# Bitmovin::Encoding::Outputs::S3Output.list
s3_output = Bitmovin::Encoding::Outputs::S3Output.find(S3_OUTPUT_ID)

# Please note inputs/outputs are not individual files but rather the
# Bucket you are reading/writing files to and they can be reused between encodings.


# This hash contains the H264 Codec Configurations we want to create
# Codec Configurations are similar to Inputs/Outputs in that they are configured once
# and can be reused for future encodings.
video_configs = [
    {name: 'h264_360p_600', profile: 'HIGH', height: 360, bitrate: 600000},
    {name: 'h264_432p_700', profile: 'HIGH', height: 432, bitrate: 700000},
    {name: 'h264_576p_1050', profile: 'HIGH', height: 576, bitrate: 1050000},
    {name: 'h264_720p_1380', profile: 'HIGH', height: 720, bitrate: 1380000},
    {name: 'h264_720p_1800', profile: 'HIGH', height: 720, bitrate: 1800000},
    {name: 'h264_1080p_2150', profile: 'HIGH', height: 1080, bitrate: 2150000},
    {name: 'h264_1080p_2900', profile: 'HIGH', height: 1080, bitrate: 2900000},
    {name: 'h264_2160p_4000', profile: 'HIGH', height: 2160, bitrate: 4000000},
    {name: 'h264_2160p_6000', profile: 'HIGH', height: 2160, bitrate: 6000000},
    {name: 'h264_2160p_8500', profile: 'HIGH', height: 2160, bitrate: 8500000},
    {name: 'h264_2160p_10000', profile: 'HIGH', height: 2160, bitrate: 10000000},

    {name: 'h265_360p_420', profile: 'main', height: 360, bitrate: 420000},
    {name: 'h265_432p_490', profile: 'main', height: 432, bitrate: 490000},
    {name: 'h265_576p_735', profile: 'main', height: 576, bitrate: 735000},
    {name: 'h265_720p_966', profile: 'main', height: 720, bitrate: 966000},
    {name: 'h265_720p_1260', profile: 'main', height: 720, bitrate: 1260000},
    {name: 'h265_1080p_1505', profile: 'main', height: 1080, bitrate: 1505000},
    {name: 'h265_1080p_2030', profile: 'main', height: 1080, bitrate: 2030000},
    {name: 'h265_2160p_2800', profile: 'main', height: 2160, bitrate: 2800000},
    {name: 'h265_2160p_4200', profile: 'main', height: 2160, bitrate: 4200000},
    {name: 'h265_2160p_5950', profile: 'main', height: 2160, bitrate: 5950000},
    {name: 'h265_2160p_7000', profile: 'main', height: 2160, bitrate: 7000000}
]

# The actual instance of the encoding task you are about to start
enc = Bitmovin::Encoding::Encodings::EncodingTask.new({
                                                          name: 'VOD h264/h265 Encoding HLS'
                                                      })
enc.save!

# Create or load the Audio Config
#audio_config = Bitmovin::Encoding::CodecConfigurations::AacConfiguration.find("<EXISTING_AAC_CONFIG_ID>")
audio_config = Bitmovin::Encoding::CodecConfigurations::AacConfiguration.new({
                                                                                 name: 'AAC_PROFILE_128k',
                                                                                 bitrate: 128000,
                                                                                 rate: 48000
                                                                             })
audio_config.save!

# Adding Audio Stream to Encoding
audio_stream = enc.streams.build(name: 'audio stream')
audio_stream.codec_configuration = audio_config
audio_stream.build_input_stream(input_path: INPUT_FILE_PATH, input_id: s3_input.id, selection_mode: 'AUTO')
audio_stream.conditions = {
    type: 'CONDITION',
    attribute: 'INPUTSTREAM',
    operator: '==',
    value: 'TRUE'
}
puts audio_stream.conditions.to_json
audio_stream.save!

# Audio Muxing
audio_muxing = enc.muxings.fmp4.build(name: 'audio-muxing', segment_length: 4)
audio_muxing.build_output({
                              output_id: s3_output.id,
                              output_path: File.join(OUTPUT_PATH, 'audio/aac')
                          })
audio_muxing.build_output({
                              output_id: s3_output.id,
                              output_path: File.join(OUTPUT_PATH, 'audio/aac'),
                              acl: [{
                                        permission: 'PUBLIC_READ'
                                    }]
                          })
audio_muxing.streams << audio_stream.id
audio_muxing.save!

# Let's also start the Manifest generation
# Multi Codec HLS Manifest
multi_hls_manifest = Bitmovin::Encoding::Manifests::HlsManifest.new({
                                                                        name: 'Multi Codec HLS manifest',
                                                                        description: 'Multi Codec HLS manifest',
                                                                        manifest_name: 'multi_playlist.m3u8'
                                                                    })

multi_hls_manifest.outputs << Bitmovin::Encoding::StreamOutput.new({
                                                                       output_id: s3_output.id,
                                                                       output_path: OUTPUT_PATH
                                                                   })
multi_hls_manifest.save!

multi_hls_manifest.build_audio_medium({
                                          name: 'HLS Audio Media',
                                          group_id: 'audio_group',
                                          segment_path: 'audio/aac',
                                          encoding_id: enc.id,
                                          stream_id: audio_stream.id,
                                          muxing_id: audio_muxing.id,
                                          language: 'en',
                                          uri: 'audio_media.m3u8'
                                      }).save!

# H264 HLS Manifest
h264_hls_manifest = Bitmovin::Encoding::Manifests::HlsManifest.new({
                                                                       name: 'H264 HLS manifest',
                                                                       description: 'Multi Codec HLS manifest',
                                                                       manifest_name: 'h264_playlist.m3u8'
                                                                   })

h264_hls_manifest.outputs << Bitmovin::Encoding::StreamOutput.new({
                                                                      output_id: s3_output.id,
                                                                      output_path: OUTPUT_PATH
                                                                  })
h264_hls_manifest.save!

h264_hls_manifest.build_audio_medium({
                                         name: 'HLS Audio Media',
                                         group_id: 'audio_group',
                                         segment_path: 'audio/aac',
                                         encoding_id: enc.id,
                                         stream_id: audio_stream.id,
                                         muxing_id: audio_muxing.id,
                                         language: 'en',
                                         uri: 'audio_media.m3u8'
                                     }).save!
# H265 HLS Manifest
h265_hls_manifest = Bitmovin::Encoding::Manifests::HlsManifest.new({
                                                                       name: 'H265 HLS manifest',
                                                                       description: 'Multi Codec HLS manifest',
                                                                       manifest_name: 'h265_playlist.m3u8'
                                                                   })

h265_hls_manifest.outputs << Bitmovin::Encoding::StreamOutput.new({
                                                                      output_id: s3_output.id,
                                                                      output_path: OUTPUT_PATH
                                                                  })
h265_hls_manifest.save!

h265_hls_manifest.build_audio_medium({
                                         name: 'HLS Audio Media',
                                         group_id: 'audio_group',
                                         segment_path: 'audio/aac',
                                         encoding_id: enc.id,
                                         stream_id: audio_stream.id,
                                         muxing_id: audio_muxing.id,
                                         language: 'en',
                                         uri: 'audio_media.m3u8'
                                     }).save!

hls_manifests = [multi_hls_manifest, h264_hls_manifest, h265_hls_manifest]

# H264 DASH Manifest
h264_dash_manifest = Bitmovin::Encoding::Manifests::DashManifest.new({
                                                                         name: 'H264 DASH Manifest',
                                                                         description: 'H264 DASH Manifest',
                                                                         manifest_name: 'h264_manifest.mpd'
                                                                     })

h264_dash_manifest.outputs << Bitmovin::Encoding::StreamOutput.new({
                                                                       output_id: s3_output.id,
                                                                       output_path: OUTPUT_PATH
                                                                   })
h264_dash_manifest.save!

h264_period = Bitmovin::Encoding::Manifests::Period.new(
    h264_dash_manifest.id
)
h264_period.save!

h264_video_adaptation_set = Bitmovin::Encoding::Manifests::VideoAdaptationSet.new(
    h264_dash_manifest.id,
    h264_period.id
)
h264_video_adaptation_set.save!

# Adding Audio Stream to H264 DASH Manifest
audio_adaptation_set = Bitmovin::Encoding::Manifests::AudioAdaptationSet.new(
    h264_dash_manifest.id,
    h264_period.id
)
audio_adaptation_set.save!

audio_adaptation_set.build_fmp4_representation({
                                                   encoding_id: enc.id,
                                                   muxing_id: audio_muxing.id,
                                                   segment_path: 'audio/aac',
                                                   type: 'TEMPLATE',
                                                   name: 'Audio Adaptation Set'

                                               }).save!

# H265 DASH Manifest
h265_dash_manifest = Bitmovin::Encoding::Manifests::DashManifest.new({
                                                                         name: 'H265 DASH Manifest',
                                                                         description: 'H265 DASH Manifest',
                                                                         manifest_name: 'h265_manifest.mpd'
                                                                     })

h265_dash_manifest.outputs << Bitmovin::Encoding::StreamOutput.new({
                                                                       output_id: s3_output.id,
                                                                       output_path: OUTPUT_PATH
                                                                   })
h265_dash_manifest.save!

h265_period = Bitmovin::Encoding::Manifests::Period.new(
    h265_dash_manifest.id
)
h265_period.save!

h265_video_adaptation_set = Bitmovin::Encoding::Manifests::VideoAdaptationSet.new(
    h265_dash_manifest.id,
    h265_period.id
)
h265_video_adaptation_set.save!

# Adding Audio Stream to H265 DASH Manifest
audio_adaptation_set = Bitmovin::Encoding::Manifests::AudioAdaptationSet.new(
    h265_dash_manifest.id,
    h265_period.id
)
audio_adaptation_set.save!

audio_adaptation_set.build_fmp4_representation({
                                                   encoding_id: enc.id,
                                                   muxing_id: audio_muxing.id,
                                                   segment_path: 'audio/aac',
                                                   type: 'TEMPLATE',
                                                   name: 'Audio Adaptation Set'

                                               }).save!

# Multi Codec DASH manifest
multi_codec_dash_manifest = Bitmovin::Encoding::Manifests::DashManifest.new({
                                                                                name: 'MULTI CODEC DASH Manifest',
                                                                                description: 'MULTI CODEC DASH Manifest',
                                                                                manifest_name: 'multi_codec_manifest.mpd'
                                                                            })

multi_codec_dash_manifest.outputs << Bitmovin::Encoding::StreamOutput.new({
                                                                              output_id: s3_output.id,
                                                                              output_path: OUTPUT_PATH
                                                                          })
multi_codec_dash_manifest.save!

multi_codec_period = Bitmovin::Encoding::Manifests::Period.new(
    multi_codec_dash_manifest.id
).save!

multi_h265_adaptation_set = Bitmovin::Encoding::Manifests::VideoAdaptationSet.new(
    multi_codec_dash_manifest.id,
    multi_codec_period.id
).save!

multi_h264_adaptation_set = Bitmovin::Encoding::Manifests::VideoAdaptationSet.new(
    multi_codec_dash_manifest.id,
    multi_codec_period.id
).save!

# Adding Audio Stream to Multi Codec DASH Manifest
audio_adaptation_set = Bitmovin::Encoding::Manifests::AudioAdaptationSet.new(
    multi_codec_dash_manifest.id,
    multi_codec_period.id
).save!

audio_adaptation_set.build_fmp4_representation({
                                                   encoding_id: enc.id,
                                                   muxing_id: audio_muxing.id,
                                                   segment_path: 'audio/aac',
                                                   type: 'TEMPLATE',
                                                   name: 'Audio Adaptation Set'

                                               }).save!

dash_manifests = [multi_codec_dash_manifest, h264_dash_manifest, h265_dash_manifest]

def create_mp4(streams, name, enc, s3_output)
  mp4_muxing = enc.muxings.mp4.build(name: "MP4 #{name} muxing", filename: "#{name}.mp4")
  mp4_muxing.streams << streams.map {|stream| stream.id}
  mp4_muxing.streams.flatten!
  mp4_muxing.build_output({
                              output_id: s3_output.id,
                              output_path: File.join(OUTPUT_PATH, name),
                              acl: [{
                                        permission: 'PUBLIC_READ'
                                    }]
                          })

  mp4_muxing.save!
  puts "Added MP4 muxing #{mp4_muxing.name}"
end

# Adding Video Streams to Encoding
video_configs.each do |config|

  if config[:name].start_with?('h264')
    video_config_type = 'H264'
  elsif config[:name].start_with?('h265')
    video_config_type = 'H265'
  else
    video_config_type = 'NONE'
  end

  if video_config_type == 'H264'
    codec_config = Bitmovin::Encoding::CodecConfigurations::H264Configuration.new(config).save!
    config = OpenStruct.new(config)

    str = enc.streams.build(name: codec_config.name)
    str.codec_configuration = codec_config
    str.build_input_stream(input_path: INPUT_FILE_PATH, input_id: s3_input.id, selection_mode: 'AUTO')
    str.conditions = {
        type: 'CONDITION',
        attribute: 'HEIGHT',
        operator: '>=',
        value: codec_config.height
    }
    str.save!

    create_mp4([str, audio_stream], codec_config.name, enc, s3_output)

    fmp4_muxing = enc.muxings.fmp4.build(name: "#{codec_config.name} muxing", segment_length: 4)
    fmp4_muxing.streams << str.id
    fmp4_muxing.build_output({
                                 output_id: s3_output.id,
                                 output_path: File.join(OUTPUT_PATH, config.name),
                                 acl: [{
                                           permission: 'PUBLIC_READ'
                                       }]
                             })
    fmp4_muxing.save!
    puts "Added FMP4 muxing #{fmp4_muxing.name}"

    h264_video_adaptation_set.build_fmp4_representation(
        encoding_id: enc.id,
        muxing_id: fmp4_muxing.id,
        type: 'TEMPLATE',
        segment_path: config.name
    ).save!
    puts "Added muxing #{fmp4_muxing.name} to #{video_config_type} only DASH manifest"

    multi_h264_adaptation_set.build_fmp4_representation(
        encoding_id: enc.id,
        muxing_id: fmp4_muxing.id,
        type: 'TEMPLATE',
        segment_path: config.name
    ).save!
    puts "Added muxing #{fmp4_muxing.name} to multi codec DASH manifest"

    h264_hls_manifest.build_stream({
                                       audio: 'audio_group',
                                       closed_captions: 'NONE',
                                       segmentPath: config.name,
                                       encoding_id: enc.id,
                                       muxing_id: fmp4_muxing.id,
                                       stream_id: str.id,
                                       uri: config.name + '.m3u8'
                                   }).save!

    puts "Added muxing #{fmp4_muxing.name} to #{video_config_type} HLS manifest"
  else
    codec_config = Bitmovin::Encoding::CodecConfigurations::H265Configuration.new(config)
    codec_config.save!
    config = OpenStruct.new(config)

    str = enc.streams.build(name: codec_config.name)
    str.codec_configuration = codec_config
    str.build_input_stream(input_path: INPUT_FILE_PATH, input_id: s3_input.id, selection_mode: 'AUTO')
    str.conditions = {
        type: 'CONDITION',
        attribute: 'HEIGHT',
        operator: '>=',
        value: codec_config.height
    }
    str.save!

    create_mp4([str, audio_stream], codec_config.name, enc, s3_output)

    fmp4_muxing = enc.muxings.fmp4.build(name: "#{codec_config.name} muxing", segment_length: 4)
    fmp4_muxing.streams << str.id
    fmp4_muxing.build_output({
                                 output_id: s3_output.id,
                                 output_path: File.join(OUTPUT_PATH, config.name),
                                 acl: [{
                                           permission: 'PUBLIC_READ'
                                       }]
                             })
    fmp4_muxing.save!
    puts "Added FMP4 muxing #{fmp4_muxing.name}"

    h265_video_adaptation_set.build_fmp4_representation(
        encoding_id: enc.id,
        muxing_id: fmp4_muxing.id,
        type: 'TEMPLATE',
        segment_path: config.name
    ).save!
    puts "Added muxing #{fmp4_muxing.name} to #{video_config_type} only DASH manifest"

    multi_h265_adaptation_set.build_fmp4_representation(
        encoding_id: enc.id,
        muxing_id: fmp4_muxing.id,
        type: 'TEMPLATE',
        segment_path: config.name
    ).save!
    puts "Added muxing #{fmp4_muxing.name} to multi codec DASH manifest"

    h265_hls_manifest.build_stream({
                                       audio: 'audio_group',
                                       closed_captions: 'NONE',
                                       segmentPath: config.name,
                                       encoding_id: enc.id,
                                       muxing_id: fmp4_muxing.id,
                                       stream_id: str.id,
                                       uri: config.name + '.m3u8'
                                   }).save!

    puts "Added muxing #{fmp4_muxing.name} to #{video_config_type} HLS manifest"
  end

  # Add the Stream to the multi codec HLS Manifest
  multi_hls_manifest.build_stream({
                                      audio: 'audio_group',
                                      closed_captions: 'NONE',
                                      segmentPath: config.name,
                                      encoding_id: enc.id,
                                      muxing_id: fmp4_muxing.id,
                                      stream_id: str.id,
                                      uri: config.name + '.m3u8'
                                  }).save!

  puts "Added muxing #{fmp4_muxing.name} to multi codec HLS manifest"
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

# Now that the encoding is finished we can start writing the m3u8 Manifest
hls_manifests.each do |hls_manifest|

  hls_manifest.start!

    while hls_manifest.status != 'FINISHED' && hls_manifest.status != 'ERROR'
      puts "HLS Manifest status is #{hls_manifest.status}"
      progress = hls_manifest.progress
      if progress > 0
        puts "Progress: #{hls_manifest.progress} %"
      end
      sleep 2
    end

    puts "HLS Manifest generation #{hls_manifest.name} finished with status #{hls_manifest.status}"

end

# Begin DASH manifests generation
dash_manifests.each do |dash_manifest|

    dash_manifest.start!

    while dash_manifest.status != 'FINISHED' && dash_manifest.status != 'ERROR'
      puts "DASH manifest generation status is #{dash_manifest.status}"
      progress = dash_manifest.progress
      if progress > 0
        puts "Progress: #{dash_manifest.progress}"
      end
      sleep 2
    end

    puts "DASH Manifest generation #{dash_manifest.name} finished with status #{dash_manifest.status}"
end

puts 'All Manifests generated!'
