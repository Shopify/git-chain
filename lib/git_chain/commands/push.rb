require 'optparse'

module GitChain
  module Commands
    class Push < Command
      include Options::ChainName

      def description
        "Push all branches of the chain to upstream"
      end

      def configure_option_parser(opts, options)
        super

        opts.on("-u", "--set-upstream", "Set upstream to matching names, if not already set") do
          options[:set_upstream] = true
        end

        opts.on("-f", "--force", "Use --force-with-lease when pushing") do
          options[:force] = true
        end
      end

      def run(options)
        raise(AbortError, "Not currently on a chain") unless options[:chain_name]

        chain = Models::Chain.from_config(options[:chain_name])
        raise(AbortError, "Chain #{options[:chain_name]} does not exist") if chain.empty?

        remote = nil
        upstreams = {}

        chain.branch_names.each do |b|
          upstream = Git.upstream_branch(branch: b)
          if upstream
            branch_remote, upstream_branch = upstream.split('/', 2)
            if remote && branch_remote != remote
              raise(AbortError, "Multiple remotes detected: #{remote}, #{branch_remote}") if remote != branch_remote
            else
              remote = branch_remote
            end
            upstreams[b] = upstream_branch
          elsif options[:set_upstream]
            upstreams[b] = b
          end
        end

        raise(AbortError, "Nothing to push") if upstreams.empty?

        remote ||= Git.exec("remote").split("\n").first
        raise(AbortError, "No remote configured") unless remote

        pairs = upstreams.map { |b, u| "#{b}:#{u}" }

        cmd = %w(git push)
        cmd << '--force-with-lease' if options[:force]
        cmd += [remote, *pairs]
        raise(AbortError, "git push failed") unless system(*cmd)

        if options[:set_upstream]
          upstreams.each do |local, upstream|
            Git.exec('branch', "--set-upstream-to=#{remote}/#{upstream}", local)
          end
        end
      end
    end
  end
end
