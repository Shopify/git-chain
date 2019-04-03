module GitChain
  module Option
    module ChainName
      def configure_option_parser(opts, options)
        super

        opts.on("-n", "--name=NAME", "Chain name") do |name|
          options[:chain_name] = name
        end
      end
    end
  end
end
