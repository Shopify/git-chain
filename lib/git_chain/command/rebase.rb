require 'optparse'

module GitChain
  class Command
    class Rebase < Command
      include Option::ChainName

      def description
        "Rebase all branches of the chain"
      end

      def run(options)
        raise(AbortError, "Current branch '#{Git.current_branch}' is not in a chain or the chain specified does not exist.") unless options[:chain_name]

        chain = GitChain::Model::Chain.from_config(options[:chain_name])

        puts "Rebasing the following branches: #{chain.branches.map(&:name)}"

        branches_to_rebase = chain.branches[1..-1]

        raise(AbortError, "No branches to rebase for chain '#{chain_name}'.") if branches_to_rebase.empty?

        branches_to_rebase.each do |branch|
          Git.exec("rebase", "--keep-empty", "--onto", branch.parent_branch, branch.branch_point, branch.name)
          parent_sha = Git.rev_parse(branch.parent_branch)
          Git.set_config("branch.#{branch.name}.branchPoint", parent_sha, scope: :local)
          # validate the parameters
        end
      end
    end
  end
end
