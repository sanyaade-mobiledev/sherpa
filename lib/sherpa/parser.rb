
module Sherpa
  class Parser

    def self.sherpa_block?(line)
      !!(line =~ /^\s*\/\/=/)
    end

    def self.line_comment?(line)
      !!(line =~ /^\s*\/\//)
    end

    def self.parse_line(line)
      cleaned = line.to_s.sub(/\s*\/\//, '').to_s.sub(/\s*=\s/, '')
      cleaned.rstrip
    end

    def self.left_trim(line, content)
      cleaned = line
      if content[content.size - 1] == "\n"
        cleaned = cleaned.lstrip
      end
      cleaned
    end

    def self.examples?(line)
      !!(line =~ /^\s*Examples/)
    end

    def self.header?(line)
      !!(line =~ /:\z/)
    end

    def self.add_markdown_header(line)
      return "## #{line}\n"
    end

    def initialize(file)
      @file_path = file
      @blocks = []
      @parsed = false
    end

    def blocks
      @parsed ? @blocks : parse_comments
    end

    def parse_comments
      File.open @file_path do |file|
        in_block = false
        in_examples = false
        current_block = nil

        file.each_line do |line|

          # Entering a block
          if self.class.sherpa_block?(line)
            in_block = true
            current_block = {}
            current_block[:description] = ''
            current_block[:examples] = nil
            @blocks.push(current_block)
          end

          if in_block && self.class.line_comment?(line)

            # Trim up the lines from comment markers and left spacing
            stripped = self.class.parse_line(line)
            stripped = self.class.left_trim(stripped, current_block[:description]) unless in_examples

            # Save the current line for tweaking
            current_line = stripped

            # If line ends with ":" turn it into an h2
            if self.class.header?(current_line)
              current_line = self.class.add_markdown_header(stripped)
            end

            # While within the examples block, add the current line to the examples object
            if in_examples
              current_block[:examples] += stripped.gsub(/^\s{4}/, "\n")
            end

            # Test if entering into an example block
            if self.class.examples?(stripped)
              current_block[:examples] = ''
              in_examples = true
            end

            # Push the current line into the description object
            current_block[:description] += "#{current_line}\n"

          else
            in_block = false
            in_examples = false
          end
        end
      end
      clean_examples()
      @blocks
    end

    # Strip out the first blank line within a
    def clean_examples()
      @blocks.each do |block|
        if block[:examples] != nil
          block[:examples] = block[:examples].gsub(/^\n/, "")
        end
      end
      @blocks
    end

  end
end

