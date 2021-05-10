# frozen_string_literal: true
require "optparse"

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
        chain = current_chain(options)
        remote = nil
        upstreams = {}

        chain.branch_names[1..-1].each do |b|
          upstream = Git.push_branch(branch: b)
          if upstream
            branch_remote, upstream_branch = upstream.split("/", 2)
            if remote && branch_remote != remote
              raise(Abort, "Multiple remotes detected: #{remote}, #{branch_remote}") if remote != branch_remote
            elsif upstream_branch
              remote = branch_remote
            end
            upstreams[b] = upstream_branch
          end

          upstreams[b] ||= b if options[:set_upstream]
        end

        raise(Abort, "Nothing to push") if upstreams.empty?

        remote ||= Git.exec("remote").split("\n").first
        raise(Abort, "No remote configured") unless remote

        pairs = upstreams.map { |b, u| "#{b}:#{u}" }

        cmd = %w(git push)
        cmd << "--force-with-lease" if options[:force]
        cmd += [remote, *pairs]

        puts_info("Pushing {{info:#{pairs.size}}} branch#{pairs.size > 1 ? "es" : ""} to #{remote}")
        puts_debug(cmd.join(" "))
        raise(Abort, "git push failed") unless system(*cmd)

        if options[:set_upstream]
          upstreams.each do |local, upstream|
            args = ["branch", "--set-upstream-to=#{remote}/#{upstream}", local]
            puts_debug_git(*args)
            Git.exec(*args)
          end
        end
      end
    end
  end
end
