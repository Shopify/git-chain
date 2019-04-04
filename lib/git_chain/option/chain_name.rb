module GitChain
  module Option
    module ChainName
      def post_process_options!(options)
        super

        unless options[:chain_name]
          branch_name = GitChain::Git.current_branch
          if branch_name
            branch = GitChain::Model::Branch.from_config(branch_name)
            options[:chain_name] = branch.chain_name unless branch.chain_name.to_s.empty?
          end
        end
      end

      def configure_option_parser(opts, options)
        super

        opts.on("-n", "--name=NAME", "Chain name") do |name|
          options[:chain_name] = name
        end
      end
    end
  end
end
