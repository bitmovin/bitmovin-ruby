# Sprite Creation
puts 'Creating sprite'
sprite = Bitmovin::Encoding::Encodings::Sprite.new('<THE ENCODING ID>',
                                                   '<THE STREAM ID>',
                                                   {
                                                       name: 'MySpriteName',
                                                       description: 'This is the sprite created during encoding',
                                                       distance: 10,
                                                       sprite_name: 'mySprite.png',
                                                       vtt_name: 'mySprite.vtt',
                                                       height: 144,
                                                       width: 256,
                                                       outputs: [{
                                                                     output_id: '<THE OUTPUT ID>',
                                                                     output_path: File.join('/path/to/your/output', 'sprites')
                                                                 }]
                                                   }).save!

puts "Created sprite with id #{sprite.id}"