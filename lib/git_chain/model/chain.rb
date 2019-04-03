module GitChain
  class Model
    class Chain < Model
      attr_reader :name, :branches

      def initialize(name:, branches:)
        @name = name
        @branches = branches
      end

      class << self
        def from_config(name)
          chains = Git.chains(chain_name: name)
          branches = chains.keys.map(&Branch.method(:from_config))

          new(
            name: name,
            branches: sort_branches(branches),
          )
        end

        def sort_branches(branches)
          sorted = []
          remaining = branches.clone

          current_parent = nil
          until remaining.empty?
            node = remaining.find { |branch| branch.parent_branch == current_parent }
            sorted << node
            remaining.delete(node)
            current_parent = node.name
          end

          sorted
        end
      end
    end
  end
end
