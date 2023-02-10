# frozen_string_literal: true
require "optparse"

module GitChain
  module Commands
    class Teardown < Command
      include Options::ChainName

      def description
        "Teardown chain"
      end

      def run(options)
        if Git.rebase_in_progress?
          raise(Abort, "A rebase is in progress. Please finish the rebase first and run 'git chain rebase' after.")
        end

        chain = current_chain(options)

        puts_debug("Tearing down chain #{chain.formatted}}}")

        branches = chain.branches
        branches.each do |b|
          Git.set_config("branch.#{b}.chain", nil, scope: :local)
          Git.set_config("branch.#{b}.parentBranch", nil, scope: :local)
          Git.set_config("branch.#{b}.branchPoint", nil, scope: :local)
        end

        puts_success("Removed chain #{chain.formatted}")
      end
    end
  end
end
