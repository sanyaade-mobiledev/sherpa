
require './lib/sherpa/parser'
require './lib/sherpa/renderer'

module Sherpa
  class Builder

    def initialize(files)
      @files = files
      @output = {}
      @output[:sherpas] = []
      @output[:deets] = {}
      @parser = Sherpa::Parser.new
      @renderer = Sherpa::Renderer.new
    end

    def publish_deets
      published = {}
      published[:published_at] = Time.now.strftime("%m/%d/%Y %I:%M%P %Z")
      published[:published_by] = `git config user.name`.gsub(/\n/, "")
      published
    end

    def build
      @files.each do |file|
        file_blocks = @parser.parse_comments file
        file_blocks = @renderer.render_blocks file_blocks
        @output[:sherpas].push file_blocks
      end
      @output[:deets] = publish_deets
      @output
    end

  end
end

