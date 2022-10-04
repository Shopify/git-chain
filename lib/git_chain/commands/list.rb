# frozen_string_literal: true
require "optparse"

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

        opts.on("--github-links", "Display GitHub links to open pull requests") do
          options[:format] = :github
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
          chain_names.each do |cn|
            puts(cn)
          end
        when :github
          chain_names.each do |cn|
            print_github_links(cn)
          end
        else
          current = current_chain
          prefix = ""

          chain_names.each do |cn|
            chain = Models::Chain.from_config(cn)
            prefix = cn == current ? "{{yellow:*}} " : "  " if current
            puts("#{prefix}#{chain.formatted}}}")
          end
        end
      end

      def print_github_links(chain_name)
        puts("{{bold:#{chain_name}}}")
        chain = Models::Chain.from_config(chain_name)
        branch_names = chain.branch_names

        # Assume that all branches in the chain have the same remote as the last branch
        remote_url = chain.remote_url
        unless remote_url
          puts("  {{error:Unable to detect remote}}")
          return
        end

        begin
          github_url, _, _ = Util::Github.parse_url(remote_url)
        rescue ArgumentError => e
          raise(Abort, "{{error:#{e}}}: {{green:#{remote_url}}}")
        end

        branch_names[0..-2].zip(branch_names[1..-1]).each do |(a, b)|
          puts("  #{github_url}/pull/new/#{a}...#{b}")
        end
      end
    end
  end
end
