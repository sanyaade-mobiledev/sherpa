
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
      @stache_layout = File.read('./lib/sherpa/layout.mustache')
      @html = ""
      @debug = debug
    end

    def build
      @files.each do |file|
        file_blocks = @parser.parse_comments file["file"]
        file_blocks.each do |file_block|
          file_block[:markup] = @renderer.render file_block[:raw]
          file_block.each do |key, value|
            if key.to_s != 'raw' && key.to_s != 'examples'
              file_block[key] = @renderer.render value
            end
          end
          file_block[:tmpl] = file["template"]
        end
        @blocks.push(file_blocks)
      end
      render_sections()
    end

    def render_sections
      @blocks.each do |block|
        block.each do |section_block|
          @html += Mustache.render(File.read(section_block[:tmpl]), :blocks => section_block)
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

    # What does the object and json look like?
    def output
      # puts @blocks
      # puts @blocks.to_json
      puts JSON.pretty_generate(@blocks)
    end
  end
end

