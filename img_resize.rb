#!/usr/local/bin/ruby

# Resize a whole directory of images to a particular width, scaling the height.

unless ARGV.length == 2
  puts "Usage: #{$0} resize_width directory_name"
end

width = ARGV[0]
dir = ARGV[1]

Dir.entries(dir).each { |f|
  m = /^(.+)\.(gif|png|jpg|jpeg)/.match(f)
  if m
    file = File.join(dir, f)
    tmp_file = File.join(dir, ".tmp_img.#{m[2]}")
    system("convert #{file} -resize #{width} #{tmp_file}");

    m2 = re = /^[-\w\d\/\.]+\s\w+\s([\dx]+)/.match(`identify #{tmp_file}`)
    new_image_file = File.join(dir, m[1] + "_" + m2[1] + "." + m[2])
    puts "Renaming \"#{tmp_file}\" to \"#{new_image_file}\""
    File.rename(tmp_file, new_image_file)
  end
}

