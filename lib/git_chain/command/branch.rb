require 'optparse'

module GitChain
  class Command
    class Branch < Command
      include GitChain::Option::ChainName

      def run(options)
        puts "Branch #{options}"
      end
    end
  end
end
