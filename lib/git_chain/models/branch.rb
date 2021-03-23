# frozen_string_literal: true
module GitChain
  module Models
    class Branch < Model
      attr_accessor :name, :chain_name, :parent_branch, :branch_point

      def initialize(name:, chain_name: nil, parent_branch: nil, branch_point: nil)
        super()
        @name = name
        @chain_name = chain_name
        @parent_branch = parent_branch
        @branch_point = branch_point
      end

      def self.from_config(name)
        new(
          name: name,
          chain_name: Git.get_config("branch.#{name}.chain"),
          parent_branch: Git.get_config("branch.#{name}.parentBranch"),
          branch_point: Git.get_config("branch.#{name}.branchPoint"),
        )
      end
    end
  end
end
