
require 'redcarpet'
module Sherpa
  class Renderer

    def initialize
      @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(),
                                          :autolink => true,
                                          :no_intra_emphasis => true,
                                          :tables => true,
                                          :fenced_code_blocks => true,
                                          :lax_html_blocks => true,
                                          :strikethrough => true,
                                          :superscript => true,
                                          :space_after_headers => true
                                         )
    end


    def render(block)
      @markdown.render(block).gsub(/^\n/, "<br />")
    end
  end
end

