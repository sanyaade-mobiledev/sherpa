
require 'json'
require 'yaml'
require './lib/sherpa/builder'
require './lib/sherpa/parser'
require './lib/sherpa/renderer'
require './lib/sherpa/sherpa_utils'
require './lib/sherpa/version'

module Sherpa
  # files = Dir["./app/assets/stylesheets/*.sass"]
  files = [
    "./app/assets/stylesheets/font-size.sass"
  ]

  config = "./sherpa.json"
  # config = "./sherpa_2.json"
  # config = "./sherpa.yaml"

  builder = Builder.new(config)
  json = JSON.pretty_generate(builder.build)
  puts json
end

