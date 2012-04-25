
require 'json'
require './lib/sherpa/builder'

module Sherpa
  # files = Dir["./app/assets/stylesheets/*.sass"]
  # files = [
    # "./app/assets/stylesheets/breadcrumbs.sass",
    # "./app/assets/stylesheets/visibility.sass",
    # "./app/assets/stylesheets/box-sizing.sass"
  # ]

  files = [
    "./app/assets/stylesheets/font-size.sass"
  ]

  builder = Builder.new(files)
  json = JSON.pretty_generate(builder.build)
  puts "--------------"
  puts json
end

