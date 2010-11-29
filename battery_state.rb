#! /usr/bin/env ruby

batt = 'BAT1'
state = File.open("/proc/acpi/battery/#{batt}/state").read
if state !~ /discharging/
  puts 'Not Available'
  exit
end
info = File.open("/proc/acpi/battery/#{batt}/info").read

m = /remaining capacity:\s+(\d+)\smAh/.match(state)
remaining = m[1]
m = /last full capacity:\s+(\d+)\smAh/.match(info)
last_full = m[1]

puts (remaining.to_f / last_full.to_f * 100.0).to_i.to_s + "%"
