module GitChainRebase
  class Command
    def self.command_name
      @command_name ||= name.split('::')
        .last
        .gsub(/([A-Z]+)([A-Z][a-z])/, '\1-\2')
        .gsub(/([a-z\d])([A-Z])/, '\1-\2')
        .downcase
    end

    def call(args)
      options = options(args)
      run(options)
    end

    def run(_options)
      raise NotImplementedError
    end

    def options(args)
      options = default_options
      command_name = command_name

      OptionParser.new do |opts|
        opts.banner = "Usage: #{GitChainRebase::EntryPoint::PRELUDE} #{command_name} [options]"
        option_parser(opts, options)
      end.parse!(args)

      # Leftover arguments
      options[:args] = args
      options
    end

    def option_parser(opts, options)
      opts.on("-n", "--name=NAME", "Chain name") do |name|
        options[:chain_name] = name
      end
    end

    def default_options
      {}
    end
  end
end
