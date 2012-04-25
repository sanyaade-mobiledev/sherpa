
require './lib/sherpa/sherpa_utils'

module Sherpa
  class Parser

    def initialize()
      @blocks = []
    end

    def parse_comments(file_path)
      @blocks = []
      File.open file_path do |file|
        in_block = false
        current_block = nil
        current_key = 'summary'

        file.each_line do |line|

          # Entering a block
          if SherpaUtils.sherpa_block? line
            in_block = true
            current_block = {}
            current_block[:raw] = ''
            current_block[:filename] = SherpaUtils.get_filename(file_path)
            current_block[current_key] = ''
            @blocks.push current_block
          end

          if in_block && SherpaUtils.line_comment?(line)

            # Trim up the lines from comment markers and right spacing
            stripped = SherpaUtils.trim_comment_markers line

            # Trim left spacing unless this is a `pre` block
            if !SherpaUtils.pre_line? stripped
              stripped = SherpaUtils.trim_left(stripped, current_block[:raw])
            end

            # Save the current line for tweaking
            current_line = stripped

            # If line ends with ":" turn it into an h2
            if SherpaUtils.header?(current_line)
              current_line = SherpaUtils.add_markdown_header(stripped)
              current_key = SherpaUtils.trim_header(current_line)
              current_block[current_key] = ''
            end

            # If in a usage block create a showcase block that gets rendered as straight markup (style guides)
            if current_key == 'usage'
              if current_block[:usage_showcase]
                current_block[:usage_showcase] += stripped.gsub(/^\s{4}/, "\n")
              else
                current_block[:usage_showcase] = ''
              end
            end

            # Push the current line into the raw object
            current_block[:raw] += "#{current_line}\n"
            current_block[current_key] += "#{current_line}\n" unless current_key == nil

          else
            in_block = false
            current_key = 'summary'
          end
        end
      end
      clean_showcase()
      @blocks
    end

    # Strip out the first blank line within a
    def clean_showcase()
      @blocks.each do |block|
        if block[:usage_showcase] != nil
          block[:usage_showcase] = block[:usage_showcase].gsub(/^\n/, "")
        end
      end
      @blocks
    end

  end
end

