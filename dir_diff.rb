#!/usr/bin/env ruby

require 'set'

def dirdiff(dir1, dir2, depth)
  return unless File.directory?(dir1) && File.directory?(dir2)
  set1, set2 = [dir1, dir2].map do |dir|
    Set.new(Dir.entries(dir).select { |e| e !~ /^\./ })
  end
  
  (set1 - set2).each do |f|
    puts File.join(dir1, f)
  end

  (set2 - set1).each do |f|
    puts File.join(dir2, f)
  end
  return if depth == 0

  set1.intersection(set2).each do |dir|
    dirdiff(File.join(dir1, dir), File.join(dir2, dir), depth - 1)
  end
end

if ARGV.length < 1 || ARGV.length > 3
  puts "Usage: #{$0} directory1 directory2 [depth]\nIf depth is omitted, it is 0."
  exit
end

dir1 = ARGV[0]
dir2 = ARGV[1]
depth = ARGV[2].to_i || 0
depth = 0 if depth < 0

dirdiff(dir1, dir2, depth)

