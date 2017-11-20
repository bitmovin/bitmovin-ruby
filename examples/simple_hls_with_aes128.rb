require 'bitmovin-ruby'

# CONFIGURATION
BITMOVIN_API_KEY = "YOUR API KEY HERE"

S3_INPUT_ID = "The ID of the Input"
S3_OUTPUT_ID = "The ID of the Output"
INPUT_FILE_PATH = "encoding/awolnation.mkv"
OUTPUT_PATH = "/encoding_test/bitmovin-ruby/#{Time.now.strftime("%v-%H-%M")}/"
M3U8_NAME = "playlist.m3u8" 

DRM_AES_KEY = "759678DC403B3CB84125E8E0F0824CD6" # Change this to something else
DRM_AES_IV = "196E6EB871BBC09191A3995318406198" 

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
  { name: "h264_720p_700",
    profile: "MAIN",
    height: 720,
    bitrate: 700000
}, {
  name: "h264_540p_500",
    profile: "MAIN",
    height: 540,
    bitrate: 500000
  }
]

# The actual instance of the encoding task you are about to start
enc = Bitmovin::Encoding::Encodings::EncodingTask.new({
  name: "VOD Encoding HLS AES128 Ruby"
})
enc.save!


# Let's also start the Manifest generation
manifest = Bitmovin::Encoding::Manifests::HlsManifest.new({
  name: 'Test Ruby Manifest',
  description: "Test encoding with ruby",
  manifest_name: M3U8_NAME
})

manifest.outputs << Bitmovin::Encoding::StreamOutput.new({
  output_id: s3_output.id,
  output_path: OUTPUT_PATH
})
manifest.save!

create_audio!(enc, manifest, s3_input, s3_output)

# Adding Video Streams to Encoding
video_configs.each do |config|
  h264_config = Bitmovin::Encoding::CodecConfigurations::H264Configuration.new(config)
  h264_config.save!
  config = OpenStruct.new(config)

  str = enc.streams.build(name: h264_config.name)
  str.codec_configuration = h264_config
  str.build_input_stream(input_path: INPUT_FILE_PATH, input_id: s3_input.id, selection_mode: 'AUTO')
  str.save!

  muxing = enc.muxings.ts.build(name: "#{h264_config.name} muxing", segment_length: 4)
  muxing.streams << str.id
  muxing.save!

  aes_muxing = muxing.drms.aes.build({
    key: DRM_AES_KEY,
    iv: DRM_AES_IV,
    method: 'AES_128',
    name: "AES DRM for #{muxing.name}"
  })
  aes_muxing.build_output({
    output_id: s3_output.id,
    output_path: File.join(OUTPUT_PATH, config.name),
    acl: [{
      permission: "PUBLIC_READ"
    }]
  })
  aes_muxing.save!
  puts "Finished DRM Muxing"

  # Add the Stream to the Manifest too
  hls_stream = manifest.build_stream({
    audio: 'audio_group',
    closed_captions: 'NONE',
    segmentPath: config.name,
    encoding_id: enc.id,
    muxing_id: muxing.id,
    stream_id: str.id,
    drm_id: aes_muxing.id,
    uri:  config.name + '.m3u8'
  })
  hls_stream.save!
end

# Starting an encoding and monitoring it's status
enc.start!

while(enc.status != 'FINISHED')
  puts "Encoding Status is #{enc.status}"
  progress = enc.progress
  if (progress > 0)
    puts "Progress: #{enc.progress} %"
  end
  sleep 2
end
puts "Encoding finished!"

# Now that the encoding is finished we can start writing the m3u8 Manifest
manifest.start!

while(manifest.status != 'FINISHED')
  puts "manifestoding Status is #{manifest.status}"
  progress = manifest.progress
  if (progress > 0)
    puts "Progress: #{manifest.progress} %"
  end
  sleep 2
end

BEGIN {
  # Begin is a hack to have this method available but define it at the end of the file
def create_audio!(enc, manifest, s3_input, s3_output)

  # Create or load the Audio Config
  #audio_config = Bitmovin::Encoding::CodecConfigurations::AacConfiguration.find("<EXISTING_AAC_CONFIG_ID>")
  audio_config = Bitmovin::Encoding::CodecConfigurations::AacConfiguration.new({
    name: "AAC_PROFILE_128k",
    bitrate: 128000,
    rate: 48000
  })
  audio_config.save!
  #
  # Adding Audio Stream to Encoding
  stream_aac = enc.streams.build(name: 'audio stream')
  stream_aac.codec_configuration = audio_config
  stream_aac.build_input_stream(input_path: INPUT_FILE_PATH, input_id: s3_input.id, selection_mode: 'AUTO')
  stream_aac.save!

  # Audio Muxing
  audio_muxing = enc.muxings.ts.build(name: 'audio-muxing', segment_length: 4)
  audio_muxing.build_output({
    output_id: s3_output.id,
    output_path: File.join(OUTPUT_PATH, "audio/aac")
  })
  audio_muxing.streams << stream_aac.id
  audio_muxing.save!

  aes_audio_muxing = audio_muxing.drms.aes.build({
    key: DRM_AES_KEY,
    iv: DRM_AES_IV,
    method: 'AES_128',
    name: "AES DRM for Audio"
  })
  aes_audio_muxing.build_output({
    output_id: s3_output.id,
    output_path: File.join(OUTPUT_PATH, "audio/aac"),
    acl: [{
      permission: "PUBLIC_READ"
    }]
  })
  aes_audio_muxing.save!
  puts "Finished DRM Muxing"

  # Adding Audio Stream to HLS Manifest
  audio_stream_medium = manifest.build_audio_medium({
    name: "HLS Audio Media",
    group_id: "audio_group",
    segment_path: "audio/aac",
    encoding_id: enc.id,
    stream_id: stream_aac.id,
    muxing_id: audio_muxing.id,
    drm_id: aes_audio_muxing.id,
    language: "en",
    uri: "audio_media.m3u8"
  })
  audio_stream_medium.save!
end
}
