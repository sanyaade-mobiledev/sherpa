
require 'sherpa/line_inspector'

#~
# Parser
module Sherpa
  class Parser
    attr_accessor :current_block, :current_key, :block_num

    def initialize()
      @inspector = Sherpa::Parsing::LineInspector
    end

    def titleized_filepath
      File.basename(@definition.filepath, File.extname(@definition.filepath)).capitalize
    end

    def parse(list)
      file_path = list[:file]
      @definition = Definition.new
      @definition.template = list[:template]
      @definition.filepath = file_path

      File.open file_path do |file|
        if @inspector.is_markdown_file?(file_path)
          parse_markdown_file(file)
        elsif @inspector.is_image_file?(file_path)
          parse_image_file(file_path)
        else
          parse_code_file(file)
        end
      end
      @definition
    end

    def parse_markdown_file(file)
      @definition.title = titleized_filepath
      file.each_line do |line|
        @definition.raw += line
      end
    end

    def parse_image_file(file)
      path = file.gsub(/^\./, "")
      title = titleized_filepath.downcase.gsub(/_|-/, " ")
      @definition.raw = "![#{title}](#{path} '#{title}')"
      @definition.title = title
    end

    def parse_code_file(file)
      self.block_num = 0
      is_multi = false
      file.each_line do |line|
        if @inspector.sherpa_block?(line)
          is_multi = @inspector.multi_comment_start?(line)
          setup_new_block
          parse_first_line line if block_num == 1
        elsif in_block?(line, is_multi)
          parse_line line
        else
          finalize_block
          is_multi = false
        end
      end
    end

    def setup_new_block
      self.current_block = Block.new
      self.current_key = 'summary'
      current_block[current_key] = ''
      self.block_num += 1
      @definition.blocks.push(current_block)
    end

    def parse_first_line(line)
      current_line = @inspector.trim_comment_markers(line)

      if @inspector.sherpa_section?(current_line) || !current_line.empty?
        current_line = "## #{current_line}\n" unless @inspector.markdown_header?(current_line)
      else current_line.empty?
        current_line = "## #{titleized_filepath}"
      end

      title = @inspector.trim_for_title current_line
      @definition.title = title
      current_block.title = title
      current_line = @inspector.trim_colon(current_line)
      add_line(current_line)
    end

    def in_block?(line, is_multi)
      return false if self.current_block.nil?
      if is_multi
        return !@inspector.multi_comment_end?(line)
      else
        return @inspector.line_comment?(line)
      end
    end

    def parse_line(line)
      current_line = normalize_line(line)
      set_block_title(current_line)
      current_line = generate_lorem(current_line)
      current_line = block_section(current_line)
      add_line(current_line)
    end

    def normalize_line(line)
      current_line = @inspector.trim_comment_markers(line)
      # Trim left spacing unless this is a `pre` block, allows for breaks in comments, but not in output
      # Seems like there could be a more efficient way here...
      if !@inspector.pre_line?(current_line)
        current_line = @inspector.trim_left(current_line, @definition.raw)
      end
      current_line
    end

    def set_block_title(current_line)
      # If not in the first sherpa block and in another one with a md heading, throw it in an array
      if block_num > 1 && @inspector.markdown_header?(current_line)
        title = @inspector.trim_for_title current_line
        @definition.subnav.push title
        current_block.title = title
      end
    end

    def generate_lorem(current_line)
      # If the line contains an `~lorem` tag, generate the lorem ipsum copy
      if @inspector.lorem?(current_line)
        current_line = @inspector.generate_lorem(current_line)
      end
      current_line
    end

    def block_section(current_line)
      # If line ends with ":" turn it into an h4 and generate a new key for storage off it's name
      if @inspector.sherpa_section?(current_line)
        current_line = @inspector.add_markdown_header(current_line)
        self.current_key = @inspector.trim_sherpa_section_for_key(current_line)
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
      current_line
    end

    def add_line(line)
      # Push the current line into the raw object and the current key block
      @definition.raw += "#{line}\n"
      current_block[current_key] += "#{line}\n"
    end

    def finalize_block
      self.current_block = nil
      self.current_key = nil
    end

  end
end

