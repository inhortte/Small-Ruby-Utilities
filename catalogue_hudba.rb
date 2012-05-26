#!/usr/bin/env ruby

dir = '/media/hranostaj/hudba'

puts '<html><head><title>Hudba</title>'
puts "<style>\nbody {\nbackground: #ccc;}\n#main {\nmargin-left: auto; margin-right: auto; width: 50%; }\n#smear {\nfont-size: 12px;}\n.alpha {\nfont-size: 16px; font-weight: bold;}\n.artist {\npadding-left:20px; font-size: 14px; font-weight: bold; }\n.album {\npadding-left:40px; font-size: 12px; font-weight: normal; }\n.mali {\nfont-weight: normal; font-size: 12px;}</style>"
puts '</head><body><div id="main">'

# first level (alpha)
alphae = Dir.entries(dir).select { |e| (e !~ /^\./) && (e !~ /misc/) }.sort
puts '<div id="smear"><a name="smear">'
a_links = alphae.map { |a| "<a href=\"##{a}\">#{a}</a>" }
puts a_links.join(" | ")
puts '</a></div>'
alphae.each do |a|
  puts "<p class=\"alpha\"><a name=\"#{a}\">" + a + "</a>&nbsp;&nbsp;<span class=\"mali\"><a href=\"#smear\">(top)</a></p>\n"

  Dir.entries(File.join(dir, a)).select { |e| e !~ /^\./ }.sort.each do |artist|
    puts "<p class=\"artist\">\n"
    puts artist.gsub("_", " ") + "<br />\n"
    puts "</p>"
    puts "<p class=\"album\">\n"

    Dir.entries(File.join(dir, a, artist)).select { |e| e !~ /^\./ }.sort.each do |album|
      puts album.gsub("_", " ") + "<br />\n"
    end
    
    puts "</p>\n"
  end
end

puts '</div></body></html>'

