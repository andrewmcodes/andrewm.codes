# frozen_string_literal: true

require "strscan"

module Serbea
  class OutputBuffer < Erubi::CaptureBlockEngine::Buffer
    def initialize(*)
      super
      @html_safe = true
    end

    def to_s
      super.tap { _1.instance_variable_set(:@html_safe, true) if html_safe? }
    end
  end

  class TemplateEngine < Erubi::CaptureBlockEngine
    FRONT_MATTER_REGEXP = %r!\A(---\s*\n.*?\n?)^((---|\.\.\.)\s*$\n?)!m

    def self.directive(new_directive, directive_resolution)
      directives[new_directive.to_s] = directive_resolution
    end

    # rubocop:disable Metrics
    def self.directives
      @directives ||= {
        "@" => ->(code, buffer) do
          pieces = code.split
          if pieces[0].start_with?(%r{[A-Z]}) # Ruby class name
            pieces[0].prepend " "
            pieces[0] << ".new("
          else # string or something else
            pieces[0].prepend "("
          end

          includes_block = false
          pieces.reverse.each do |piece|
            next unless piece == "do" && (pieces.last == "do" || pieces.last.end_with?("|"))

            piece.prepend(") ")
            includes_block = true
            break
          end

          pieces.last << ")" unless includes_block
          buffer << "{%= render#{pieces.join(" ")} %}"
        end,
        "`" => ->(code, buffer) do
          buffer << "{%= %`"
          buffer << code.gsub(%r("([^\\]?)\#{(.*?)}"), "\"\\1\#{h(\\2)}\"")
          buffer << ".strip %}"
        end,
      }
    end
    # rubocop:enable Metrics

    class << self
      attr_writer :front_matter_preamble

      def front_matter_preamble
        @front_matter_preamble ||= "frontmatter = YAML.load"
      end

      def yaml_header?(template)
        template.lines.first&.match? %r!\A---\s*\r?\n!
      end
      alias_method :has_yaml_header?, :yaml_header?
    end

    def initialize(input, properties = {})
      properties[:regexp] = %r{{%(={1,2}|-|\#|%)?(.*?)([-=])?%}([ \t]*\r?\n)?}m
      properties[:strip_front_matter] = true unless properties.key?(:strip_front_matter)
      super(process_serbea_input(input, properties), properties)
    end

    # rubocop:disable Metrics
    def process_serbea_input(template, properties)
      buff = +""

      string = template.dup
      if properties[:strip_front_matter] && self.class.yaml_header?(string) && (string = string.match(FRONT_MATTER_REGEXP))
        require "yaml" if self.class.front_matter_preamble.include?(" = YAML.load")

        string = "{% #{self.class.front_matter_preamble} <<~YAMLDATA\n#{
            string[1].sub(%r{^---\n}, "")
          }YAMLDATA\n%}#{
            string[2].sub(%r{^---\n}, "")
          }#{string.post_match}"
      end

      # Ensure the raw "tag" will strip out all ERB-style processing
      until string.empty?
        text, code, string = string.partition(%r{{% raw %}(.*?){% endraw %}}m)

        buff << text
        next unless code.length.positive?

        buff << ::Regexp.last_match(1)
          .gsub("{{", "__RAW_START_PRINT__")
          .gsub("}}", "__RAW_END_PRINT__")
          .gsub("{%", "__RAW_START_EVAL__")
          .gsub("%}", "__RAW_END_EVAL__")
      end

      # Process any pipelines
      string = buff
      buff = +""
      until string.empty?
        text, code, string = string.partition(%r{{{(.*?)}}}m)

        buff << text
        next unless code.length.positive?

        original_line_length = code.lines.size

        s = StringScanner.new(::Regexp.last_match(1))
        escaped_segment = ""
        segments = []
        until s.eos?
          portion = s.scan_until(%r{\|>?})
          if portion
            if portion.end_with?('\|')
              # the pipe is escaped, so save that for later
              escaped_segment += portion.sub(%r{\\\|$}, "|")
            elsif escaped_segment.length.positive?
              # we already have escaped content, so finish that up
              segments << (escaped_segment + portion.sub(%r{\|>?$}, ""))
              escaped_segment = ""
            elsif s.check(%r{\|})
              # let's find out if this is actionable now
              s.pos += 1
              escaped_segment += "#{portion}|"
            # nope, the next character is another pipe, so let's escape
            else
              # finally, we have liftoff!
              segments << portion.sub(%r{\|>?$}, "")
            end
          else
            # we've reached the last bit of the code
            segments << if escaped_segment.length.positive?
                          # escape and get the rest
                          (escaped_segment + s.rest)
                        else
                          # or just the rest will do
                          s.rest
                        end
            s.terminate
          end
        end

        segments[0] = "pipeline(binding, (#{segments[0].strip}))"
        segments[1..].each_with_index do |segment, index|
          filter, args = segment.strip.match(%r{([^ :]*)(.*)}m).captures
          segments[index + 1] = ".filter(:#{filter}"
          segments[index + 1] += if args == ""
                                   ")"
                                 else
                                   ",#{args.sub(%r{^:}, "")})"
                                 end
        end

        subs = "{%= #{segments.join} %}"
        buff << subs

        (original_line_length - subs.lines.size).times do
          buff << "\n{% %}" # preserve original line length
        end
      end

      # Process any render directives
      string = buff
      buff = +""
      end_matches = ["end", ""]
      until string.empty?
        text, code, string = string.partition(%r{{%@([a-z_`]+)?(.*?)%}}m)

        buff << text
        next unless code.length.positive?

        code = ::Regexp.last_match(2)
        if end_matches.include? code.strip
          buff << "{% end %}"
        else
          directive = ::Regexp.last_match(1) ? self.class.directives[::Regexp.last_match(1)] : self.class.directives["@"]

          unless directive
            raise Serbea::Error,
                  "Handler for Serbea template directive `#{::Regexp.last_match(1)}' not found"
          end

          additional_length = "#{buff}#{code}".lines.size
          directive.(code, buff)
          (additional_length - buff.lines.size).times do
            buff << "{% %}\n" # preserve original directive line length
          end

        end
      end

      buff
    end
    # rubocop:enable Metrics

    private

    # Don't allow `{%==` to output escaped strings, it should be identical
    # to `{%=`
    def add_expression_result_escaped(code)
      add_expression_result(code)
    end

    def add_postamble(postamble)
      src << postamble
      src << "#{@bufvar}.html_safe"

      src.gsub!("__RAW_START_PRINT__", "{{")
      src.gsub!("__RAW_END_PRINT__", "}}")
      src.gsub!("__RAW_START_EVAL__", "{%")
      src.gsub!("__RAW_END_EVAL__", "%}")
    end
  end
end
