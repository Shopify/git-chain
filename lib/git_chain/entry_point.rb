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
      end

      def print_usage
        puts "Invalid usage"
      end

      def commands
        @commands ||= GitChain::Commands.constants
          .map(&GitChain::Commands.method(:const_get))
          .select { |c| c < GitChain::Command }
          .map { |c| [c.command_name, c] }
          .to_h
      end
    end
  end
end
