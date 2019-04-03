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

      def banner_options
        "<start_point> <branch>..."
      end

      def description
        "Configure a chain with a list of branches"
      end

      def run(options)
        current_branches = Git.branches
        branches = options[:args]
        missing = branches - current_branches

        raise(AbortError, "Branch does not exist: #{missing.join(', ')}") unless missing.empty?

        current = Git.current_branch
        puts current
      end
    end
  end
end
