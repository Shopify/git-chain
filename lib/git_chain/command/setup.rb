require 'optparse'

module GitChain
  module Commands
    class Setup < Command
      def run(options)
        puts "Hello #{options}"
      end
    end
  end
end
