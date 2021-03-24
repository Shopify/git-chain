# frozen_string_literal: true
module GitChain
  module Options
    module ChainName
      def post_process_options!(options)
        super

        unless options[:chain_name]
          branch_name = Git.current_branch
          if branch_name
            branch = Models::Branch.from_config(branch_name)
            options[:chain_name] = branch.chain_name if branch.chain_name
          end
        end
      end

      def current_chain(options)
        raise(Abort, "Current branch '#{Git.current_branch}' is not in a chain.") unless options[:chain_name]

        chain = GitChain::Models::Chain.from_config(options[:chain_name])
        raise(Abort, "Chain '#{options[:chain_name]}' does not exist.") if chain.empty?

        chain
      end

      def configure_option_parser(opts, options)
        super

        opts.on("-c", "--chain=NAME", "Chain name") do |name|
          options[:chain_name] = name
        end
      end
    end
  end
end
