require_relative './lib/bitmovin'

Bitmovin.init("d4010de5-7152-4456-a20d-1fa5835f091b")

Bitmovin::Encoding::Manifests::DashManifest.list.each { |m| m.delete! }
Bitmovin::Encoding::Manifests::DashManifest.new({
  name: "Test manifest",
  description: "My super manifest",
  manifest_name: "Foo-Bar",
  outputs: [
    output_id: Bitmovin::Encoding::Outputs::GcsOutput.list.first.id,
    output_path: '/lk_portal_tests/test-daniel/test.mpd'
  ]
}).save!
