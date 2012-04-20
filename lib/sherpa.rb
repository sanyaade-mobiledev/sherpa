
require './lib/sherpa/parser'
require './lib/sherpa/renderer'
require 'mustache'
require 'json'

module Sherpa
  @parser = Sherpa::Parser.new('./app/assets/stylesheets/visibility.sass')
  @renderer = Sherpa::Renderer.new

  blocks = @parser.blocks
  blocks.each do |block|
    block[:markup] = @renderer.render block[:description]
  end

  blocks.each do |block|
    puts '---------------------------------------------------------------------------'
    puts '------ Description --------'
    puts block[:description]
    puts '--------- Markup ----------'
    puts block[:markup]
    puts '-------- Examples ---------'
    puts block[:examples]
  end
  puts '---------------------------------------------------------------------------'
  puts blocks.to_json

  templ_stache = File.read('./lib/sherpa/layout.mustache')
  html = Mustache.render(templ_stache, :blocks => blocks)
  File.open('./index.html', "w") do |file|
    file.write(html)
  end
end

