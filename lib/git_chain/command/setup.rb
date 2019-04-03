require 'optparse'

module GitChain
  class Command
    class Setup < Command
      include GitChain::Option::ChainName

      def run(options)
        puts "Setup #{options}"
      end
    end
  end
end