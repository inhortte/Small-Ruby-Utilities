#!/usr/bin/env ruby

require 'rubygems'
require 'datamapper'
require 'dm-mysql-adapter'

DataMapper.setup(:default, 'mysql://localhost/morning_quiz')

class Arithmetic
  include DataMapper::Resource

  property :id, Serial
  property :question_count, Integer
  property :score, Float
  property :time, Integer
  property :type, String
  property :created_at, DateTime
  property :updated_at, DateTime
end

choices = { 1 => :+, 2 => :* }

puts "Good morning, Schweinehund."
puts "1) Addition"
puts "2) Multiplication"
while !choices.keys.include?(choice = gets.chomp.to_i)
  puts "Don't fuck with me, sunshine!"
end

puts "How many questions, you dullard?"
while (count = gets.chomp.to_i) < 1
  puts "You are straining our relationship, cabbage-boy."
end

puts "Ready?"
gets
start = Time.now
correct = 0

count.downto(1).each do |i|
  fst = rand(9) * 10 + rand(9)
  snd = rand(9) * 10 + rand(9)
  ans = fst.send(choices[choice], snd)
  puts "Question ##{count - i + 1}: #{fst} #{choices[choice].to_s} #{snd}"
  if gets.chomp.to_i == ans
    correct = correct + 1
    puts "Very good, vole."
  else
    puts "Nope!"
  end
end

finish = Time.now
score = correct.to_f / count.to_f * 100

puts "From #{count}, you answered #{correct} correctly."
puts "Your score is %.02f%%" % score
puts "It took you #{finish.tv_sec - start.tv_sec} seconds."

Arithmetic.create(:question_count => count,
                  :score => score,
                  :time => finish.tv_sec - start.tv_sec,
                  :type => choices[choice].to_s)
