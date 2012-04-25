
module Sherpa
  class SherpaUtils

    # Determines if a comment block has a sherpa marker (//~)
    # TODO: Should accept a specific comment marker for a given file type (#~, /*~, /**~)
    def self.sherpa_block?(line)
      !!(line =~ /^\s*\/\/~/)
    end

    # Determines if a line is a continuation of a sherpa block
    def self.line_comment?(line)
      !!(line =~ /^\s*\/\//)
    end

    def self.pre_line?(line)
      !!(line =~ /^\s{4,}/)
    end

    # Tests for the special heading "Examples"
    # NOTE: not being used currently
    def self.examples?(line)
      !!(line =~ /^\s*Examples/)
    end

    # Tests for the special heading "Usage"
    # NOTE: not being used currently
    def self.usage?(line)
      !!(line =~ /^\s*Usage/)
    end

    # Tests to see if the line ends in ":"
    def self.header?(line)
      !!(line =~ /:\z/)
    end

    # Remove comment markers, sherpa identifier and EOL whitespace
    def self.trim_comment_markers(line)
      cleaned = line.to_s.sub(/\s*\/\//, '').to_s.sub(/\s*~\s/, '')
      cleaned.rstrip
    end

    # Clean the left side of the comment block if the line ends with a line break
    def self.trim_left(line, content)
      cleaned = line
      if content[content.size - 1] == "\n"
        cleaned = cleaned.lstrip
      end
      cleaned
    end

    # Trim the header of markdown and tail colon
    def self.trim_header(line)
      cleaned = line.to_s.sub(/#+/, '').to_s.sub(/:/, '')
      cleaned.strip.downcase
    end

    # Return a markdown header unless it already starts in markdown format
    def self.add_markdown_header(line)
      line = "### #{line}\n" unless !!(line =~ /^#/)
      line
    end

    # NOTE: not being used currently
    def self.get_title(file)
      parent = File.dirname(file).split('/').last
      title = File.basename(file, File.extname(file)).gsub(/_/, "")
      "<h2 id='#{parent}_#{title}'>#{title.capitalize}</h2>"
    end

    # Return the current filename and it's parent directory
    def self.get_filename(file)
      parent = File.dirname(file).split('/').last
      "#{parent}/#{File.basename(file)}"
    end

  end
end

