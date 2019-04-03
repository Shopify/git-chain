require 'optparse'

module GitChain
  class Command
    class Setup < Command
      include Option::ChainName

      def post_process_options!(options)
        raise(CommandArgError, "Expects at least 2 arguments") unless options[:args].size >= 2

        super

        options[:chain_name] = options[:args][1] unless options[:chain_name]
      end

      def banner_options
        "<start_point> <branch>..."
      end

      def description
        "Configure a chain with a list of branches"
      end

      def run(options)
        current_branches = Git.branches
        branch_names = options[:args]
        missing = branch_names - current_branches

        raise(AbortError, "Branch does not exist: #{missing.join(', ')}") unless missing.empty?

        $stderr.puts("Setting up chain #{options[:chain_name]}")

        chain = Model::Chain.from_config(options[:chain_name])
        chain_branch_names = chain.branches.map(&:name)

        branches = branch_names.each_with_index.map do |b, i|
          current = chain.branches[i]
          if current&.name == b
            current
          else
            Model::Branch.from_config(b)
          end
        end

        branches.each_with_index do |b, i|
          unless b.chain_name == chain.name
            if b.chain_name
              raise(AbortError, "Branch #{b.name} is currently attached to chain #{b.chain_name}")
            else
              Git.set_config("branch.#{b.name}.chain", chain.name, scope: :local)
            end
          end

          parent_branch = i > 0 ? chain.branches[i - 1].name : nil
          if b.parent_branch != parent_branch
            raise(AbortError, "Branch #{b.name} is currently based on #{b.parent_branch}") unless parent_branch
            Git.set_config("branch.#{b.name}.parentBranch", parent_branch, scope: :local)
          end

          branch_point = nil
          if parent_branch
            parsed = Git.rev_parse(parent_branch)
            merge_base = Git.merge_base(parent_branch, b.name)
            raise(AbortError, "Branch #{b.name} is not based on #{b.parent_branch}") unless parsed == merge_base
            branch_point = parsed
          end

          if b.branch_point != branch_point
            raise(AbortError, "Branch #{b.name} is currently based on #{b.branch_point}") unless branch_point
            Git.set_config("branch.#{b.name}.branchPoint", branch_point, scope: :local)
          end
        end

        removed = chain_branch_names - branch_names
        removed.each do |b|
          Git.set_config("branch.#{b}.chain", nil, scope: :local)
          Git.set_config("branch.#{b}.parentBranch", nil, scope: :local)
          Git.set_config("branch.#{b}.branchPoint", nil, scope: :local)
        end

        puts "New: #{branch_names.join(' -> ')}"
        puts "Removed: #{removed}"

        Git.exec('checkout', branch_names.last)
      end
    end
  end
end
