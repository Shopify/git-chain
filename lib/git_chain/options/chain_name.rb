module GitChain
  module Options
    module ChainName
      def post_process_options!(options)
        super

        unless options[:chain_name]
          branch_name = Git.current_branch
          if branch_name
            branch = Models::Branch.from_config(branch_name)
            options[:chain_name] = branch.chain_name unless branch.chain_name.to_s.empty?
          end
        end
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
