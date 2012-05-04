
module Sherpa
  class Parser

    def initialize()
    end

    def parse(file_path)
      @blocks = {}
      @blocks[:raw] = ''
      @blocks[:markup] = ''
      @blocks[:title] = ''
      @blocks[:subnav] = []
      @blocks[:filepath] = file_path
      @blocks[:sherpas] = []

      File.open file_path do |file|
        in_block = false
        block_num = 0
        first_line = true
        current_block = nil
        current_key = nil

        file.each_line do |line|

          # Entering a block
          if Utils.sherpa_block?(line)
            in_block = true
            current_block = {}
            current_key = 'summary'
            current_block[current_key] = ''
            block_num += 1
            @blocks[:sherpas].push(current_block)
          end

          if in_block && Utils.line_comment?(line)

            # Trim up the lines from comment markers and right spacing
            current_line = Utils.trim_comment_markers(line)

            # Trim left spacing unless this is a `pre` block, allows for breaks in comments, but not in output
            # Seems like there could be a more efficient way here...
            if !Utils.pre_line?(current_line)
              current_line = Utils.trim_left(current_line, @blocks[:raw])
            end

            # Generate the title and trim up the colon for the very first block in the set
            if first_line
              if Utils.sherpa_section?(current_line) || !current_line.empty?
                current_line = "## #{current_line}\n" unless !!(current_line =~ /^#/)
              else current_line.empty?
                current_line = "## #{File.basename(file_path, File.extname(file_path)).capitalize}"
              end
              title = Utils.trim_for_title current_line
              @blocks[:title] = title
              current_block[:title] = title
              current_line = Utils.trim_colon(current_line)
              first_line = false
            end

            # If not in the first sherpa block and in another one with a md heading, throw it in an array
            if block_num > 1 && Utils.markdown_header?(current_line)
              title = Utils.trim_for_title current_line
              @blocks[:subnav].push title
              current_block[:title] = title
            end

            # If line ends with ":" turn it into an h4 and generate a new key for storage off it's name
            if Utils.sherpa_section?(current_line)
              current_line = Utils.add_markdown_header(current_line)
              current_key = Utils.trim_sherpa_section_for_key(current_line)
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
            @blocks[:raw] += "#{current_line}\n"
            current_block[current_key] += "#{current_line}\n"

          else
            in_block = false
          end
        end
      end
      @blocks[:sherpas] = tidy_showcase(@blocks[:sherpas])
      @blocks
    end

    # Strip out the first blank line within the usage showcase block
    def tidy_showcase(blocks)
      blocks.each do |block|
        if block[:usage_showcase] != nil
          block[:usage_showcase] = block[:usage_showcase].gsub(/^\n/, "")
        end
      end
      blocks
    end

  end
end

