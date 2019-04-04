require 'optparse'

module GitChain
  module Commands
    class Setup < Command
      include Options::ChainName

      def post_process_options!(options)
        raise(ArgError, "Expects at least 2 arguments") unless options[:args].size >= 2

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
        branch_names = options[:args]

        unless (missing = branch_names - Git.branches).empty?
          raise(AbortError, "Branch does not exist: #{missing.join(', ')}")
        end

        raise(AbortError, "Branches are not all connected") if Git.merge_base(*branch_names).nil?

        puts("Setting up chain #{options[:chain_name]}")

        chain = Models::Chain.from_config(options[:chain_name])
        chain_branch_names = chain.branch_names

        branches = branch_names.each_with_index.map do |b, i|
          current = chain.branches[i]
          if current&.name == b
            current
          else
            Models::Branch.from_config(b)
          end
        end

        branches.each_with_index do |b, i|
          next if i == 0 # Skip the base, it can belong to anything

          unless b.chain_name == chain.name
            if b.chain_name
              raise(AbortError, "Branch #{b.name} is currently attached to chain #{b.chain_name}")
            else
              Git.set_config("branch.#{b.name}.chain", chain.name, scope: :local)
              b.chain_name = chain.name
            end
          end

          parent_branch = branches[i - 1].name
          if b.parent_branch != parent_branch
            puts("Changing parent branch of #{b.name} from #{b.parent_branch} to #{parent_branch}") if b.parent_branch
            Git.set_config("branch.#{b.name}.parentBranch", parent_branch, scope: :local)
            b.parent_branch = parent_branch
          end

          branch_point = nil
          if parent_branch
            parsed = Git.rev_parse(parent_branch)
            merge_base = Git.merge_base(parent_branch, b.name)
            unless parsed == merge_base
              puts("#{b.name} is not currently branched from the tip of #{b.parent_branch}")
            end
            branch_point = merge_base
          end

          next unless b.branch_point != branch_point
          raise(AbortError, "Branch #{b.name} is currently based on #{b.branch_point}") unless branch_point
          Git.set_config("branch.#{b.name}.branchPoint", branch_point, scope: :local)
          b.branch_point = branch_point
        end

        removed = chain_branch_names - branch_names
        removed.each do |b|
          Git.set_config("branch.#{b}.chain", nil, scope: :local)
          Git.set_config("branch.#{b}.parentBranch", nil, scope: :local)
          Git.set_config("branch.#{b}.branchPoint", nil, scope: :local)
        end

        puts "New: #{branch_names.join(' -> ')}"
        puts "Removed: #{removed}"
      end
    end
  end
end
