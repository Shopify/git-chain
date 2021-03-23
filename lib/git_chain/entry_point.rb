# frozen_string_literal: true
module GitChain
  module EntryPoint
    PRELUDE = "git chain"

    class << self
      include Util::Output

      def call(args)
        name = args.shift
        unless name
          GitChain::Logger.info(usage)
          return 0
        end

        cmd = commands[name]
        unless cmd
          puts_warning("Unknown command: #{name}")
          puts(usage)
          raise(AbortSilent)
        end

        cmd.new.call(args)
        0
      rescue Abort => e
        puts_error(e.message)
        1
      rescue AbortSilent
        1
      end

      def usage
        table = commands.values
          .map(&:new)
          .map { |c| [c.banner, c.description] }
          .sort
          .to_h

        column_size = table.keys.map(&:size).max

        <<~EOS
          {{bold:Usage:}}
            {{command:#{PRELUDE}}} {{info:<command>}}

          {{bold:Available commands:}}
          #{table.map { |banner, desc| "  #{format("%-#{column_size}s", banner)}   #{desc}" }.join("\n")}
        EOS
      end

      def commands
        Commands.commands
      end
    end
  end
end
