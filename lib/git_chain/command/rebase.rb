require 'optparse'

module GitChain
  class Command
    class Rebase < Command
      include GitChain::Option::ChainName

      def run(options)
        puts "Rebase #{options}"
      end
    end
  end
end
