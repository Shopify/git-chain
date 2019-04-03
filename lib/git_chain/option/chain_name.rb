module GitChain
  module Option
    module ChainName
      def default_options
        super.tap do |options|
          options[:chain_name] = nil
        end
      end

      def option_parser(opts, options)
        super

        opts.on("-n", "--name=NAME", "Chain name") do |name|
          options[:chain_name] = name
        end
      end
    end
  end
end
