
require 'json'
require 'mustache'
require './lib/sherpa/parser'
require './lib/sherpa/renderer'

module Sherpa
  @blocks = []
  @parser = Sherpa::Parser.new
  @renderer = Sherpa::Renderer.new
  @stache_section = File.read('./lib/sherpa/section.mustache')
  @stache_layout = File.read('./lib/sherpa/layout.mustache')
  @html = ""

  files = [
    './app/assets/stylesheets/visibility.sass',
    './app/assets/stylesheets/test.sass',
    './app/assets/stylesheets/breadcrumbs.sass'
  ]

  files.each do |file|
    file_blocks = @parser.parse_comments file
    file_blocks.each do |file_block|
      file_block[:markup] = @renderer.render file_block[:description]
    end
    @blocks.push(file_blocks)
  end

  @blocks.each do |block|
    block.each do |section_block|
      @html += Mustache.render(@stache_section, :blocks => section_block)

      # puts '---------------------------------------------------------------------------'
      # puts "\n------ Description --------"
      # puts section_block[:description]
      # puts '--------- Markup ----------'
      # puts section_block[:markup]
      # puts '-------- Examples ---------'
      # puts section_block[:examples]
    end
  end

  # puts @blocks
  # puts @blocks.to_json
  # puts JSON.pretty_generate(@blocks)

  layout = Mustache.render(@stache_layout, :layout => @html)
  File.open('./index.html', "w") do |file|
    file.write(layout)
  end
end

