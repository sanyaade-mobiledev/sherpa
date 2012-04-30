
module Sherpa
  class Parser

    def initialize()
    end

    def parse(file_path)
      @blocks = []
      File.open file_path do |file|
        in_block = false
        current_block = nil
        current_key = nil

        file.each_line do |line|

          # Entering a block
          if SherpaUtils.sherpa_block?(line)
            in_block = true
            current_block = {}
            current_block[:raw] = ''
            current_block[:filepath] = file_path
            current_key = 'summary'
            current_block[current_key] = ''
            @blocks.push(current_block)
          end

          if in_block && SherpaUtils.line_comment?(line)

            # Trim up the lines from comment markers and right spacing
            current_line = SherpaUtils.trim_comment_markers(line)

            # Trim left spacing unless this is a `pre` block, allows for breaks in comments, but not in output
            if !SherpaUtils.pre_line?(current_line)
              current_line = SherpaUtils.trim_left(current_line, current_block[:raw])
            end

            # If line ends with ":" turn it into an h3 and generate a new key for storage off it's name
            if SherpaUtils.header?(current_line)
              current_line = SherpaUtils.add_markdown_header(current_line)
              current_key = SherpaUtils.trim_header_for_key(current_line)
              current_block[current_key] = ''
            end

            # If in a usage block create a showcase block that gets rendered as straight markup (style guides)
            if current_key == 'usage'
              if current_block[:usage_showcase]
                current_block[:usage_showcase] += current_line.gsub(/^\s{4}/, "\n")
              else
                current_block[:usage_showcase] = ''
              end
            end

            # Push the current line into the raw object and the current key block
            current_block[:raw] += "#{current_line}\n"
            current_block[current_key] += "#{current_line}\n"

          else
            in_block = false
          end
        end
      end
      tidy_showcase()
      @blocks
    end

    # Strip out the first blank line within the usage showcase block
    def tidy_showcase()
      @blocks.each do |block|
        if block[:usage_showcase] != nil
          block[:usage_showcase] = block[:usage_showcase].gsub(/^\n/, "")
        end
      end
      @blocks
    end

  end
end

