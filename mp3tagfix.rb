#! /usr/local/bin/ruby

require 'rubygems'
require 'mp3info'

dir = ARGV[0]
Dir.chdir dir
path = FileUtils.pwd
album = File.basename(FileUtils.pwd).gsub("_", " ")
Dir.chdir ".."
artist = File.basename(FileUtils.pwd).gsub("_", " ")
Dir.chdir path

files = Dir.entries(dir).select { |f|
  /.mp3$/.match(f)
}

files.each { |f|
  m = /^(\d+)[- _]+(.+)\.mp3$/.match(f)
  track_number = m[1].to_i
  title = m[2].split.map { |s| s.capitalize }.join(" ")
  puts "Tagging: #{f}"
  mp3 = Mp3Info.new(f)
  mp3.removetag1
  mp3.removetag2
  mp3.flush
  mp3.tag.tracknum = track_number
  mp3.tag.title = title
  mp3.tag.artist = artist
  mp3.tag.album = album
  mp3.close
}
