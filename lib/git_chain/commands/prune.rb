# frozen_string_literal: true
require "optparse"

module GitChain
  module Commands
    class Prune < Command
      include Options::ChainName

      def description
        "Prune overlapping branches from the chain"
      end

      def configure_option_parser(opts, options)
        super

        opts.on("-d", "--delete", "Delete merged branches") do
          options[:delete] = true
        end
      end

      def run(options)
        if Git.rebase_in_progress?
          raise(Abort, "A rebase is in progress. Please finish the rebase first and run 'git chain rebase' after.")
        end

        chain = current_chain(options)

        puts_debug("Pruning chain #{chain.formatted}}}")

        branches = chain.branches
        head = branches.first
        setup = [head.name]
        remove = []
        branches[1..-1].each do |branch|
          if Git.ancestor?(ancestor: branch.name, rev: head.name)
            remove << branch.name
          else
            setup << branch.name
            head = branch
          end
        end

        if remove.empty?
          puts_debug("Chain {{info:#{chain.name}}} is already up-to-date.")
          return
        end

        Git.exec("checkout", setup.last)

        Setup.new.run(chain_name: chain.name, args: setup)

        if options[:delete]
          remove.each do |branch|
            puts_info("Deleting branch {{info:#{branch}}}")
            args = ["branch", "--delete", "--force", branch]
            puts_debug_git(*args)
            Git.exec(*args)
          end
        end
      end
    end
  end
end
