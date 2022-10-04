# frozen_string_literal: true
module GitChain
  module Models
    class Chain < Model
      attr_accessor :name, :branches

      def initialize(name:, branches: [])
        super()
        @name = name
        @branches = branches
      end

      def branch_names
        branches.map(&:name)
      end

      def empty?
        branches.empty?
      end

      def formatted
        "{{info:#{name}}} {{reset:[{{cyan:#{branch_names.join(" ")}}}]}}"
      end

      def remote_url
        remote = nil
        branch_names.reverse_each do |branch|
          remote = Git.remote_url(branch: branch)
          break if remote
        end
        remote
      end

      class << self
        def from_config(name)
          chains = Git.chains(chain_name: name)
          branches = chains.keys.map(&Branch.method(:from_config))

          parents = branches.map(&:parent_branch).compact
          missing = parents - chains.keys

          raise(Abort, "More that one start branch: #{missing}.") if missing.size > 1

          branches << Branch.new(name: missing.first, chain_name: name) if missing.size.positive?

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
            raise(Abort, "Branch '#{current_parent}' is not connected to the rest of the chain") unless node

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
