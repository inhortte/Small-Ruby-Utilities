#! /usr/bin/env ruby

level = `setpci -s 00:02.0 F4.B`.chop.hex
if ARGV.length == 0
  puts level.to_s + " (hex: " + level.to_s(base = 16) + ")"
  exit
end

unless ['down', 'up'].include? ARGV[0]
  exit
end

level = level.send(ARGV[0] == 'down' ? :- : :+, 16)
level = 0 if level < 0
level = 255 if level > 255

`setpci -s 00:02.0 F4.B=#{level.to_s(base = 16)}`

