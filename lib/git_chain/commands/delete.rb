# frozen_string_literal: true
require "optparse"

module GitChain
  module Commands
    class Delete < Command
      include Options::ChainName

      def description
        "Delete chain"
      end

      def run(options)
        if Git.rebase_in_progress?
          raise(Abort, "A rebase is in progress. Please finish the rebase first and run 'git chain rebase' after.")
        end

        chain = current_chain(options)

        puts_debug("Deleting chain #{chain.formatted}}}")

        branches = chain.branches
        branches.each do |b|
          Git.set_config("branch.#{b}.chain", nil, scope: :local)
          Git.set_config("branch.#{b}.parentBranch", nil, scope: :local)
          Git.set_config("branch.#{b}.branchPoint", nil, scope: :local)
        end
  
        unless branches.empty?
          puts_warning("Removed #{branches.map { |b| "{{info:#{b}}}" }.join(", ")} from the chain.")
        end
  
        puts_success("Deleted chain #{chain.formatted}")
      end
    end
  end
end
