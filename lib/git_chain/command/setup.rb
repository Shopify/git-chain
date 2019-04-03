require 'optparse'

module GitChain
  class Command
    class Setup < Command
      include Option::ChainName

      def post_process_options!(options)
        raise(CommandArgError, "Expects at least 2 arguments") unless options[:args].size >= 2

        super

        options[:chain_name] = options[:args][1] unless options[:chain_name]
      end

      def run(options)
        puts "Setup #{options}"
      end
    end
  end
end
