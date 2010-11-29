#! /usr/bin/env ruby

require 'yaml'
require 'time'

input_file = '/home/polaris/.new_mail.yml'
max_mails = 4

mail = YAML::load(File.open(input_file).read)

if ARGV.length == 0
  puts mail.size
  exit
end

mail.each do |m|
  puts ''
  puts Time.parse(m[:sent]).localtime.strftime("%d %b %Y %H.%M")
  puts "From: #{m[:from_name]}"
  puts "Email: #{m[:from_email]}"
  puts "Subject: #{m[:subject]}"
end

