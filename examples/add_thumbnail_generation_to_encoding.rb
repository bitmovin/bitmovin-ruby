# Thumbnail Creation
puts 'Creating thumbnails!'
thumbnail = Bitmovin::Encoding::Encodings::Thumbnail.new('<YOUR ENCODING ID>',
                                                         '<THE STREAM ID TO CREATE THUMBNAILS FROM>',
                                                         {
                                                             positions: [5, 10 , 15, 20, 25],
                                                             unit: 'SECONDS',
                                                             height: 320,
                                                             pattern: 'thumb_%number%.png',
                                                             outputs: [{
                                                                           output_id: 'YOUR OUTPUT ID',
                                                                           output_path: File.join('path/to/your/output', 'thumbnails')
                                                                       }]
                                                         }).save!

puts "Created thumbnail with id #{thumbnail.id}"