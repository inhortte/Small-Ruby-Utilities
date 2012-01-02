#! /usr/bin/env ruby

batt = '/sys/class/power_supply/BAT1'
#state = File.open("/proc/acpi/battery/#{batt}/state").read
#if state !~ /discharging/
#  puts 'Not Available'
#  exit
#end
#info = File.open("/proc/acpi/battery/#{batt}/info").read

#m = /remaining capacity:\s+(\d+)\smAh/.match(state)
#remaining = m[1]
#m = /last full capacity:\s+(\d+)\smAh/.match(info)
#last_full = m[1]

status = File.open("#{batt}/status").read.chomp
remaining = File.open("#{batt}/charge_now").read
last_full = File.open("#{batt}/charge_full").read
puts status + " " + (remaining.to_f / last_full.to_f * 100.0).to_i.to_s + "%"
