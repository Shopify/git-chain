require 'optparse'

module GitChain
  class Command
    class Rebase < Command
      include Option::ChainName

      def description
        "Rebase all branches of the chain"
      end

      def run(options)
        if Git.rebase_in_progress?
          raise(AbortError, "A rebase is in progress. Please finish the rebase first and run 'git chain rebase' after.")
        end

        raise(AbortError, "Current branch '#{Git.current_branch}' is not in a chain.") unless options[:chain_name]

        chain = GitChain::Model::Chain.from_config(options[:chain_name])
        raise(AbortError, "Chain '#{Git.chain}' does not exist.") if chain.empty?

        puts "Rebasing the following branches: #{chain.branch_names}"

        branches_to_rebase = chain.branches[1..-1]

        raise(AbortError, "No branches to rebase for chain '#{chain_name}'.") if branches_to_rebase.empty?

        branches_to_rebase.each do |branch|
          begin
            parent_sha = Git.rev_parse(branch.parent_branch)

            if forwardable_branch_point?(branch)
              Git.set_config("branch.#{branch.name}.branchPoint", parent_sha)
            end

            Git.exec("rebase", "--keep-empty", "--onto", branch.parent_branch, branch.branch_point, branch.name)
            Git.set_config("branch.#{branch.name}.branchPoint", parent_sha, scope: :local)
            # validate the parameters
          rescue GitChain::Git::Failure => e
            puts "Cannot merge #{branch.name} onto #{branch.parent_branch}. Fix the rebase and run 'git chain rebase' again.\n\n#{e.message}"
            return
          end
        end
      end

      private

      def forwardable_branch_point?(branch)
        Git.merge_base(branch.branch_point, Git.merge_base(branch.parent_branch, branch.name)) == branch.branch_point
      end
    end
  end
end
