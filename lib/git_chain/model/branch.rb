module GitChain
  class Model
    class Branch < Model
      attr_reader :name, :parent_branch, :branch_point

      def initialize(name:, parent_branch:, branch_point:)
        @name = name
        @parent_branch = parent_branch
        @branch_point = branch_point
      end

      def self.from_config(name)
        new(
          name: name,
          parent_branch: Git.get_config("branch.#{name}.parentBranch"),
          branch_point: Git.get_config("branch.#{name}.branchPoint"),
        )
      end
    end
  end
end
