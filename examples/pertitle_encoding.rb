require 'bitmovin-ruby'

# CONFIGURATION
BITMOVIN_API_KEY = "YOUR API KEY"

INPUT_BUCKET_NAME = "BUCKET NAME"
INPUT_ACCESS_KEY = "YOUR AWS ACCESS KEY"
INPUT_SECRET_KEY = "YOUR AWS SECRET KEY"
INPUT_FILE_PATH = "path/to/input/file.mp"

OUTPUT_BUCKET_NAME = "BUCKET NAME"
OUTPUT_ACCESS_KEY = "YOUR AWS ACCESS KEY"
OUTPUT_SECRET_KEY = "YOUR AWS SECRET KEY"
OUTPUT_BASE_PATH = "path/to/output"

Bitmovin.init(BITMOVIN_API_KEY)

# Create the input resource to access the input file
s3_input = Bitmovin::Encoding::Inputs::S3Input.new({
  accessKey: INPUT_ACCESS_KEY,
  secretKey: INPUT_SECRET_KEY,
  bucketName: INPUT_BUCKET_NAME
}).save!

# Create the output resource to write the output files
s3_output = Bitmovin::Encoding::Outputs::S3Output.new({
  accessKey: OUTPUT_ACCESS_KEY,
  secretKey: OUTPUT_SECRET_KEY,
  bucketName: OUTPUT_BUCKET_NAME
}).save!

# Create the encoding
enc = Bitmovin::Encoding::Encodings::EncodingTask.new({
  name: "Ruby Per-Title Example"
})
enc.save!


# This will create the Per-Title template video stream. This stream will be used as a template for the Per-Title 
# encoding.The Codec Configuration, Muxings, DRMs and Filters applied to the generated Per-Title profile will be
# based on the same, or closest matching resolutions defined in the template.
# Please note, that template streams are not necessarily used for the encoding - they are just used as template.

video_config = Bitmovin::Encoding::CodecConfigurations::H264Configuration.new({
  name: "H264_Profile",
  profile: "HIGH"
})
video_config.save!

video_stream = enc.streams.build(name: 'H264 1280x720 700kb/s')
video_stream.codec_configuration = video_config
video_stream.mode = "PER_TITLE_TEMPLATE"
video_stream.build_input_stream(input_path: INPUT_FILE_PATH, input_id: s3_input.id, selection_mode: 'AUTO')
video_stream.save!


# This will create the audio stream that will be encoded with the given codec configuration.

audio_config = Bitmovin::Encoding::CodecConfigurations::AacConfiguration.new({
  name: "AAC_PROFILE_128k",
  bitrate: 128000,
  rate: 48000
})
audio_config.save!

audio_stream = enc.streams.build(name: 'audio stream')
audio_stream.codec_configuration = audio_config
audio_stream.build_input_stream(input_path: INPUT_FILE_PATH, input_id: s3_input.id, selection_mode: 'AUTO')
audio_stream.save!


# An MP4 muxing will be created for with the Per-Title video stream template and the audio stream.
# This muxing must at least define one of the placeholders {uuid} or {bitrate} in the output path.
# Placeholders will be replaced during the generation of the Per-Title.

mp4_muxing = enc.muxings.mp4.build(name: 'H264 1280x720 700kb/s')
mp4_muxing.build_output({
  output_id: s3_output.id,
  output_path: File.join(OUTPUT_BASE_PATH, "{width}_{bitrate}_{uuid}"),
  acl: [{
    permission: "PUBLIC_READ"
  }]
})
mp4_muxing.filename = "video.mp4"
mp4_muxing.streams << video_stream.id
mp4_muxing.streams << audio_stream.id
mp4_muxing.save!


# The encoding will be started with the per title and the auto representations property set. If auto
# representation is set, stream configurations will be automatically added to the Per-Title profile. In that case
# at least one PER_TITLE_TEMPLATE stream configuration must be available. All other configurations will be
# automatically chosen by the Per-Title algorithm. All relevant settings for streams and muxings will be taken from
# the closest PER_TITLE_TEMPLATE stream defined. The closest stream will be chosen based on the resolution
# specified in the codec configuration.

enc.start!({
  encoding_mode: "THREE_PASS",
  per_title: {
    h264_configuration: {
      auto_representations: {}
    }
  }
})

while(enc.status != 'FINISHED')
  puts "Encoding Status is #{enc.status}"
  progress = enc.progress
  if (progress > 0)
    puts "Progress: #{enc.progress} %"
  end
  sleep 5
end
puts "Encoding finished!"