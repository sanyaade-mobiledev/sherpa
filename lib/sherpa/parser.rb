

module Sherpa
  class Parser

    def self.sherpa_block?(line)
      !!(line =~ /^\s*\/\/~/)
    end

    def self.line_comment?(line)
      !!(line =~ /^\s*\/\//)
    end

    def self.examples?(line)
      !!(line =~ /^\s*Examples/)
    end

    def self.usage?(line)
      !!(line =~ /^\s*Usage/)
    end

    def self.header?(line)
      !!(line =~ /:\z/)
    end

    # Remove comment markers, sherpa identifier and EOL whitespace
    def self.trim_comments(line)
      cleaned = line.to_s.sub(/\s*\/\//, '').to_s.sub(/\s*~\s/, '')
      cleaned.rstrip
    end

    def self.trim_left(line, content)
      cleaned = line
      if content[content.size - 1] == "\n"
        cleaned = cleaned.lstrip
      end
      cleaned
    end

    def self.trim_header(line)
      cleaned = line.to_s.sub(/#+/, '').to_s.sub(/:/, '')
      cleaned.strip.downcase
    end

    # Return a markdown header unless it already starts in markdown format
    def self.add_markdown_header(line)
      line = "### #{line}\n" unless !!(line =~ /^#/)
      line
    end

    def self.get_title(file)
      parent = File.dirname(file).split('/').last
      title = File.basename(file, File.extname(file)).gsub(/_/, "")
      "<h2 id='#{parent}_#{title}'>#{title.capitalize}</h2>"
    end

    def self.get_filename(file)
      parent = File.dirname(file).split('/').last
      "#{parent}/#{File.basename(file)}"
    end

    def initialize()
      @blocks = []
    end

    def parse_comments(file_path)
      @blocks = []
      File.open file_path do |file|
        in_block = false
        in_examples = false
        in_usage = false
        current_block = nil
        current_key = 'summary'

        file.each_line do |line|

          # Entering a block
          if self.class.sherpa_block?(line)
            in_block = true
            current_block = {}
            current_block[:raw] = ''
            # current_block[:title] = self.class.get_title(file_path)
            current_block[:filename] = self.class.get_filename(file_path)
            current_block[:examples] = nil
            current_block[current_key] = ''
            @blocks.push(current_block)
          end

          if in_block && self.class.line_comment?(line)

            # Trim up the lines from comment markers and left spacing
            stripped = self.class.trim_comments(line)
            if in_examples == false && in_usage == false
              stripped = self.class.trim_left(stripped, current_block[:raw])
            end

            # Save the current line for tweaking
            current_line = stripped

            # If line ends with ":" turn it into an h2
            if self.class.header?(current_line)
              current_line = self.class.add_markdown_header(stripped)
              current_key = self.class.trim_header(current_line)
              current_block[current_key] = '' unless current_key == 'examples'
            end

            # While within the examples block, add the current line to the examples object
            if in_examples
              current_block[:examples] += stripped.gsub(/^\s{4}/, "\n")
            end

            # Test if entering into a usage block
            if self.class.usage?(stripped)
              in_examples = false
              in_usage = true
            end

            # Test if entering into an example block
            if self.class.examples?(stripped)
              current_block[:examples] = ''
              in_examples = true
              in_usage = false
              current_key = 'example_code'
              current_block[current_key] = ''
            end

            # Push the current line into the raw object
            current_block[:raw] += "#{current_line}\n"
            current_block[current_key] += "#{current_line}\n" unless current_key == nil

          else
            in_block = false
            in_examples = false
            in_usage = false
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

