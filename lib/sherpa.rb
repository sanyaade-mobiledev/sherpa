
require 'json'
require 'mustache'
require './lib/sherpa/parser'
require './lib/sherpa/renderer'

module Sherpa

  class Builder
    def initialize(files, debug=false)
      @files = files
      @blocks = []
      @parser = Sherpa::Parser.new
      @renderer = Sherpa::Renderer.new
      @stache_section = File.read('./lib/sherpa/section.mustache')
      @stache_layout = File.read('./lib/sherpa/layout.mustache')
      @html = ""
      @debug = debug
    end

    def build
      @files.each do |file|
        file_blocks = @parser.parse_comments file
        file_blocks.each do |file_block|
          file_block[:markup] = @renderer.render file_block[:description]
        end
        @blocks.push(file_blocks)
      end
      render_sections()
    end

    def render_sections
      @blocks.each do |block|
        block.each do |section_block|
          @html += Mustache.render(@stache_section, :blocks => section_block)
          spect(section_block) unless @debug == false
        end
      end
      render_layout()
    end

    def render_layout
      layout = Mustache.render(@stache_layout, :layout => @html)
      File.open('./index.html', "w") do |file|
        file.write(layout)
      end
    end

    def spect(block)
      puts '----------------------------------------'
      puts "\n------ Description --------"
      puts block[:description]
      puts '--------- Markup ----------'
      puts block[:markup]
      puts '-------- Examples ---------'
      puts block[:examples]
    end

    def output
      puts @blocks
      # puts @blocks.to_json
      puts JSON.pretty_generate(@blocks)
    end
  end

  builder = Builder.new(Dir["./app/assets/stylesheets/*.sass"], false)
  builder.build
  # builder.output
end

