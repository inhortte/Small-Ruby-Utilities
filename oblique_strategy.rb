#!/usr/local/bin/ruby

# require 'rubygems'
# require 'dm-core'
require 'yaml'

# DataMapper.setup(:default, 'mysql://localhost/polaris')

# class ObliqueStrategy
#   include DataMapper::Resource

#   property :id, Serial
#   property :oblique_strategy, String
# end

os = YAML::load(File.new(File.join(File.dirname(__FILE__), "oblique_strategies.yml")).read)
# puts ObliqueStrategy.get(rand(ObliqueStrategy.count) + 1).oblique_strategy
puts os[rand(os.count) + 1]

