module GitChain
  module EntryPoint
    PRELUDE = "git chain"

    class << self
      def call(args)
        name = args.shift
        return print_usage unless name

        cmd = commands[name]
        return print_usage unless cmd

        cmd.new.call(args)
        0
      rescue AbortError => e
        $stderr.puts(e.message)
        1
      rescue AbortSilentError
        1
      end

      def print_usage
        puts "Invalid usage"
      end

      def commands
        @commands ||= Command.constants
          .map(&Command.method(:const_get))
          .select { |c| c < Command }
          .map { |c| [c.command_name, c] }
          .to_h
      end
    end
  end
end
