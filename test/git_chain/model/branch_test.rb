# frozen_string_literal: true
require "test_helper"

module GitChain
  module Models
    class BranchTest < Minitest::Test
      include RepositoryTestHelper

      def test_from_config
        with_test_repository("a-b-chain") do
          branch = Branch.from_config("a")
          assert_equal("a", branch.name)
          assert_equal("master", branch.parent_branch)
          assert_equal("default", branch.chain_name)
        end
      end
    end
  end
end
