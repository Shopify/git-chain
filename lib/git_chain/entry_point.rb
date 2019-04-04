module GitChain
  module EntryPoint
    PRELUDE = "git chain"

    class << self
      def call(args)
        name = args.shift
        unless name
          GitChain::Logger.info(usage)
          return 0
        end

        cmd = commands[name]
        unless cmd
          GitChain::Logger.error("Unknown command: #{name}")
          GitChain::Logger.info(usage)
          raise(AbortSilentError)
        end

        cmd.new.call(args)
        0
      rescue AbortError => e
        GitChain::Logger.error(e.message)
        1
      rescue AbortSilentError
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
          Usage: {{bold:Available commands}}
            #{PRELUDE} <command>

          Commands:
          #{table.map { |banner, desc| "  #{format("%-#{column_size}s", banner)}   #{desc}" }.join("\n")}
        EOS
      end

      def commands
        Commands.commands
      end
    end
  end
end
