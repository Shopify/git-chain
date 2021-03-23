# frozen_string_literal: true
require "optparse"

module GitChain
  module Commands
    class Command
      include Util::Output

      def self.command_name
        @command_name ||= name.split("::")
          .last
          .gsub(/([A-Z]+)([A-Z][a-z])/, '\1-\2')
          .gsub(/([a-z\d])([A-Z])/, '\1-\2')
          .downcase
      end

      def command_name
        self.class.command_name
      end

      def call(args = [])
        options = options(args)
        run(options)
      rescue ArgError, OptionParser::ParseError => e
        GitChain::Logger.error(e.message)
        GitChain::Logger.info(usage)
        raise(AbortSilent)
      end

      def run(_options)
        raise NotImplementedError
      end

      def usage
        parser, _ = option_parser
        parser.to_s
      end

      def banner
        "{{command:#{command_name}}} {{info:#{banner_options}}}"
      end

      def banner_options
        ""
      end

      def description
        ""
      end

      def options(args)
        parser, options = option_parser
        parser.parse!(args)
        parser.summarize

        # Leftover arguments
        options[:args] = args
        post_process_options!(options)

        options
      end

      def option_parser
        options = default_options

        parser = OptionParser.new do |opts|
          opts.banner = "{{bold:Usage:}} {{command:#{EntryPoint::PRELUDE}}} #{banner}"
          configure_option_parser(opts, options)
        end

        [parser, options]
      end

      def configure_option_parser(_opts, _options)
      end

      def default_options
        {}
      end

      def post_process_options!(_options)
      end
    end
  end
end
