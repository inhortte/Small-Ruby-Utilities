#!/usr/bin/env ruby

# From metaflac to eyeD3
#tag_map = { "ALBUM" => "-A", "ARTIST" => "-a", "DISCNUMBER" => "-d",
#  "GENRE" => "-G", "TITLE" => "-t", "TRACK" => "-n" }
tag_map = { "ALBUM" => "-A", "ARTIST" => "-a",
  "GENRE" => "-G", "TITLE" => "-t", "TRACK" => "-n" }

dir = ARGV[0] || '.'
Dir.chdir dir
Dir.entries('.').select { |f| f =~ %r{\.flac$} }.each do |file|
  tags = {}
  m = %r{^(\d+)\D}.match(file)
  if m
    tags.merge!("TRACK" => m[1].to_i)
  end
  m = %r{^(.+)\.flac$}.match(file)
  wav_filename = "#{m[1]}.wav"
  mp3_filename = "#{m[1]}.mp3"

  puts "Converting #{file} from flac to wav..."
  system("flac -d \"#{file}\"")
  puts "Converting #{wav_filename} from wav to mp3..."
  system("lame -h -b 320 \"#{wav_filename}\" \"#{mp3_filename}\"")

  tag_map.keys.each do |flac_tag|
    cmd = "metaflac --show-tag=#{flac_tag} \"#{file}\""
    tag = `#{cmd}`.strip
    if tag.nil? || tag.empty?
      cmd = "metaflac --show-tag=#{flac_tag.downcase} \"#{file}\""
      tag = `#{cmd}`.strip
      if tag.nil? || tag.empty?
        cmd = "metaflac --show-tag=#{flac_tag.downcase.capitalize} \"#{file}\""
        tag = `#{cmd}`.strip
      end
    end
    unless tag.nil? || tag.empty?
      tags.merge!(flac_tag => tag.split(/=/).last)
    end
  end
  
  puts "Tagging #{mp3_filename}..."
  cmd = "eyeD3 -v2 --to-v2.4 " + tag_map.keys.map { |k| "#{tag_map[k]} \"#{tags[k]}\"" }.join(' ') + " \"#{mp3_filename}\""
  system(cmd)
end

puts "Removing flac and wav files..."
system("rm *.flac")
system("rm *.wav")

puts "Finito!"
