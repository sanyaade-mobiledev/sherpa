
require 'redcarpet'

#~
# The renderer utilizes the [redcarpet gem](https://github.com/tanoku/redcarpet) 
# for generating markdown. It renders each section within a sherpa block ignoring
# the `usage_showcase` and `title` sections.

module Sherpa
  class Renderer

    # Instantiate the markdown renderer
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


    # Render given block and replace starting new lines with an html line break
    def render(section)
      @markdown.render(section).gsub(/^\n/, "<br />")
    end

    # Render all blocks passed within a file
    def render_blocks(blocks)
      blocks[:markup] = render(blocks[:raw])
      subblocks = blocks[:sherpas]
      subblocks.each do |block|
        block.each do |key, value|
          if key.to_s != 'usage_showcase' && key.to_s != 'title'
            block[key] = render(value)
          end
        end
      end
      blocks
    end

  end
end

