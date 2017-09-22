require 'bitmovin-ruby'

# CONFIGURATION
BITMOVIN_API_KEY = "YOUR API KEY HERE"
AWS_ACCESS_KEY = "YOUR AWS_ACCESS_KEY"
AWS_SECRET_KEY = "YOUR AWS_SECRET_KEY"
BUCKET_NAME = "YOUR BUCKET NAME HERE"
INPUT_FILE_PATH = "path/to/input/file.mp4"
OUTPUT_PATH = "path/to/output"

OUTPUT_AWS_ACCESS_KEY = "YOUR AWS_ACCESS_KEY"
OUTPUT_AWS_SECRET_KEY = "YOUR AWS_SECRET_KEY"

Bitmovin.init(BITMOVIN_API_KEY)


# This will create a Input Bucket you can reuse in future encodings
# To get a list of all your S3Inputs do:
# Bitmovin::Encoding::Inputs::S3Input.list

s3_input = Bitmovin::Encoding::Inputs::S3Input.new({
  accessKey: AWS_ACCESS_KEY,
  secretKey: AWS_SECRET_KEY,
  bucketName: BUCKET_NAME
}).save!

# This will create a Output Bucket you can reuse in future encodings
# To get a list of all your Output do:
# Bitmovin::Encoding::Outputs::S3Output.list
s3_output = Bitmovin::Encoding::Outputs::S3Output.new({
  accessKey: OUTPUT_AWS_ACCESS_KEY,
  secretKey: OUTPUT_AWS_SECRET_KEY,
  bucketName: BUCKET_NAME
}).save!


# Please note inputs/outputs are not individual files but rather the 
# Bucket you are reading/writing files to and they can be reused between encodings.


# Codec Configurations are similar to Inputs/Outputs in that they are configured once
# and can be reused for future encodings. 
codec_config_720_700 = Bitmovin::Encoding::CodecConfigurations::H264Configuration.new({
  name: "H264 1280x720 700kb/s",
  profile: "MAIN",
  width: 1280,
  height: 720,
  bitrate: 700000
})
codec_config_720_700.save!
codec_config_720_1500 = Bitmovin::Encoding::CodecConfigurations::H264Configuration.new({
  name: "H264 1280x720 1500kb/s",
  profile: "MAIN",
  width: 1280,
  height: 720,
  bitrate: 1500000
})
codec_config_720_1500.save!
codec_config_720_2400 = Bitmovin::Encoding::CodecConfigurations::H264Configuration.new({
  name: "H264 1280x720 2400kb/s",
  profile: "MAIN",
  width: 1280,
  height: 720,
  bitrate: 2400000
})
codec_config_720_2400.save!

audio_config = Bitmovin::Encoding::CodecConfigurations::AacConfiguration.new({
  name: "AAC_PROFILE_128k",
  bitrate: 128000,
  rate: 48000
})
audio_config.save!







# The actual instance of the encoding task you are about to start
enc = Bitmovin::Encoding::Encodings::EncodingTask.new({
  name: "VOD Encoding Ruby",
  cloud_region: "AWS_US_EAST_1"
})
enc.save!

# Stream Configuration

stream_720_700 = enc.streams.build(name: 'H264 1280x720 700kb/s')
stream_720_700.codec_configuration = codec_config_720_700
stream_720_700.build_input_stream(input_path: INPUT_FILE_PATH, input_id: s3_input.id, selection_mode: 'AUTO')
stream_720_700.save!

stream_720_1500 = enc.streams.build(name: 'H264 1280x720 1500/s')
stream_720_1500.codec_configuration = codec_config_720_1500
stream_720_1500.build_input_stream(input_path: INPUT_FILE_PATH, input_id: s3_input.id, selection_mode: 'AUTO')
stream_720_1500.save!

stream_720_2400 = enc.streams.build(name: 'H264 1280x720 2400/s')
stream_720_2400.codec_configuration = codec_config_720_2400
stream_720_2400.build_input_stream(input_path: INPUT_FILE_PATH, input_id: s3_input.id, selection_mode: 'AUTO')
stream_720_2400.save!

stream_aac = enc.streams.build(name: 'audio stream')
stream_aac.codec_configuration = audio_config
stream_aac.build_input_stream(input_path: INPUT_FILE_PATH, input_id: s3_input.id, selection_mode: 'AUTO')
stream_aac.save!

# Muxing Configuration

mp4_muxing_720_700 = enc.muxings.mp4.build(name: 'H264 1280x720 700kb/s', filename: '700.mp4')
mp4_muxing_720_700.build_output({
  output_id: s3_output.id,
  output_path: File.join(OUTPUT_PATH, "video/")
})
mp4_muxing_720_700.streams << stream_720_700.id
mp4_muxing_720_700.streams << stream_aac.id
mp4_muxing_720_700.save!

mp4_muxing_720_1500 = enc.muxings.mp4.build(name: 'H264 1280x720 1500kb/s', filename: '1500.mp4')
mp4_muxing_720_1500.build_output({
  output_id: s3_output.id,
  output_path: File.join(OUTPUT_PATH, "video/")
})
mp4_muxing_720_1500.streams << stream_720_1500.id
mp4_muxing_720_1500.streams << stream_aac.id
mp4_muxing_720_1500.save!

mp4_muxing_720_2400 = enc.muxings.mp4.build(name: 'H264 1280x720 2400kb/s', filename: '2400.mp4')
mp4_muxing_720_2400.build_output({
  output_id: s3_output.id,
  output_path: File.join(OUTPUT_PATH, "video/")
})
mp4_muxing_720_2400.streams << stream_720_2400.id
mp4_muxing_720_2400.streams << stream_aac.id
mp4_muxing_720_2400.save!

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
