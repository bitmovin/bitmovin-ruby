require 'bitmovin-ruby'

# CONFIGURATION
BITMOVIN_API_KEY = "YOUR API KEY"

INPUT_BUCKET_NAME = "BUCKET NAME"
INPUT_ACCESS_KEY = "YOUR AWS ACCESS KEY"
INPUT_SECRET_KEY = "YOUR AWS SECRET KEY"
INPUT_FILE_PATH = "path/to/input/file.mp4"

INPUT_TRIMMING_OFFSET = 10
INPUT_TRIMMING_DURATION = 120

OUTPUT_BUCKET_NAME = "BUCKET NAME"
OUTPUT_ACCESS_KEY = "YOUR AWS ACCESS KEY"
OUTPUT_SECRET_KEY = "YOUR AWS SECRET KEY"
OUTPUT_BASE_PATH = "path/to/output"

Bitmovin.init(BITMOVIN_API_KEY)

# Create the input resource to access the input file
s3_input = Bitmovin::Encoding::Inputs::S3Input.new(
  accessKey: INPUT_ACCESS_KEY,
  secretKey: INPUT_SECRET_KEY,
  bucketName: INPUT_BUCKET_NAME
).save!

# Create the output resource to write the output files
s3_output = Bitmovin::Encoding::Outputs::S3Output.new(
  accessKey: OUTPUT_ACCESS_KEY,
  secretKey: OUTPUT_SECRET_KEY,
  bucketName: OUTPUT_BUCKET_NAME
).save!

# Create the encoding
enc = Bitmovin::Encoding::Encodings::EncodingTask.new({
  name: "VOD Encoding Ruby",
})
enc.save!

# This creates the video configuration
video_config = Bitmovin::Encoding::CodecConfigurations::H264Configuration.new(
  name: "H264_Profile",
  bitrate: 200_000,
  profile: "HIGH"
)
video_config.save!

# To be possible to cut/trim the input video it is needed to create two additional entities here.
# Instead of create just a stream with an inline input stream we need to create an external input stream
# that could be of the Ingest type
ingest_input_stream = Bitmovin::Encoding::Encodings::InputStreams::Ingest.new(
  enc.id,
  input_path: INPUT_FILE_PATH,
  input_id: s3_input.id,
  selection_mode: 'AUTO'
)
ingest_input_stream.save!

# Now it is needed to create the trimming input stream. In this example we will use the TimeBased one, but there
# other types that could be used.
time_based_trimming_input_stream = Bitmovin::Encoding::Encodings::InputStreams::Trimming::TimeBased.new(
  enc.id,
  input_stream_id: ingest_input_stream.id,
  offset: INPUT_TRIMMING_OFFSET,
  duration: INPUT_TRIMMING_DURATION
)
time_based_trimming_input_stream.save!

# Now we create the stream, linking it to the trimming input stream crated before
video_stream = enc.streams.build(name: 'H264 1280x720 700kb/s')
video_stream.codec_configuration = video_config
video_stream.build_input_stream(input_stream_id: time_based_trimming_input_stream.id)
video_stream.save!

# This will create the audio stream that will be encoded with the given codec configuration.
audio_config = Bitmovin::Encoding::CodecConfigurations::AacConfiguration.new({
  name: "AAC_PROFILE_128k",
  bitrate: 128000,
  rate: 48000
})
audio_config.save!

# This will create the audio stream, using the same trimming input stream used by the video stream
audio_stream = enc.streams.build(name: 'audio stream')
audio_stream.codec_configuration = audio_config
audio_stream.build_input_stream(input_stream_id: time_based_trimming_input_stream)
audio_stream.save!

# This will create the muxing that outputs our encoding to a file
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

# Start the encoding proccess
enc.start!

# Monitor the encoding finish
while(enc.status != 'FINISHED')
  puts "Encoding Status is #{enc.status}"
  progress = enc.progress
  if (progress > 0)
    puts "Progress: #{enc.progress} %"
  end
  sleep 5
end
puts "Encoding finished!"
