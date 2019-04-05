require 'optparse'

module GitChain
  module Commands
    class List < Command
      def banner_options
        "<chain name>"
      end

      def description
        "List existing chains"
      end

      def configure_option_parser(opts, options)
        super

        opts.on("-s", "--short", "Only display chain names") do
          options[:format] = :short
        end
      end

      def current_chain
        branch_name = Git.current_branch
        return nil unless branch_name

        branch = Models::Branch.from_config(branch_name)
        branch.chain_name
      end

      def run(options)
        chain_name = options[:args].first
        chain_names = Git.chains(chain_name: chain_name).values.uniq.sort
        return(AbortSilent) if chain_names.empty? && chain_name

        case options[:format]
        when :short
          chain_names.each(&GitChain::Logger.method(:info))
        else
          current = current_chain
          prefix = ''

          chain_names.each do |cn|
            chain = Models::Chain.from_config(cn)
            branches = chain.branch_names.map { |b| "{{cyan:#{b}}}" }

            prefix = cn == current ? "{{yellow:*}} " : "  " if current
            GitChain::Logger.info("#{prefix}{{blue:#{chain.name}}} [#{branches.join(' -> ')}]")
          end
        end
      end
    end
  end
end
