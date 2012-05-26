#!/usr/local/rvm/rubies/ruby-1.8.7-p358/bin/ruby

require 'rubygems'
require 'mongo'
require 'date'

tsq_file = "#{ENV['HOME']}/infinite_bliss/alfred/books/Three_Subject_Quotebook"
quotes = File.open(tsq_file).read.split("\n\n")
db = Mongo::Connection.new.db("tsq")
metaquote_coll = db.collection("metaquote")
quote_coll = db.collection("quote")
author_coll = db.collection("author")

def make_date(d_string)
  d = d_string.split(%r{/})
  if d.count == 1 && d[0] != "?"
    d = [d[0], 1, 1]
  elsif d.count == 2
    d = [d[1], d[0], 1]
  elsif d.count == 3
    d = [d[2], d[0], d[1]]
  else
    d = [1970, 1, 1]
  end
  Time.mktime(d[0], d[1], d[2]).to_i * 1000
end

quotes.each do |quote|
  quote.gsub!("\n", "").strip!
  date_m = %r{\(([\?\d/]+)\)$}.match(quote)
  mq_id = metaquote_coll.insert({"quote_ids" => [],
                                  "datestamp" => make_date(date_m[1])})
  quote.scan(%r{"(.*?)"\s*-([\w\s]+)}).each do |q|
    q[1].strip!
    author = author_coll.find_one({"name" => q[1]})
    author_id = author ? author["_id"] : author_coll.insert({"name" => q[1]})
    quote_id = quote_coll.insert({"quote" => q[0], "author_id" => author_id})
    metaquote_coll.update({"_id" => mq_id},
                          {"$set" => {"quote_ids" =>
                              metaquote_coll.find_one({"_id" => mq_id})["quote_ids"].push(quote_id)}})
  end
end
