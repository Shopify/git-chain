require 'optparse'

module GitChain
  class Command
    class Rebase < Command
      include Option::ChainName

      def description
        "Rebase all branches of the chain"
      end

      def run(options)
        puts "Rebase #{options}"
      end
    end
  end
end
