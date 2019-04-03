require 'optparse'

module GitChain
  class Command
    class Branch < Command
      include Option::ChainName

      def banner_options
        "<start_point> branch"
      end

      def description
        "Start a new branch, adding it to the chain"
      end

      def run(options)
        puts "Branch #{options}"
      end
    end
  end
end
