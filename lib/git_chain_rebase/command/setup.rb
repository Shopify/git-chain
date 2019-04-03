require 'optparse'

module GitChainRebase
  module Commands
    class Setup < Command
      def run(options)
        puts "Hello #{options}"
      end
    end
  end
end
