require '../helper'

module GitChain
  class Model
    class TestChain < MiniTest::Test
      include RepositoryTestHelper

      def test_from_config
        with_test_repository('a-b-c-chain') do
          chain = Chain.from_config('default')
          assert_equal('default', chain.name)
          assert_equal(%w(master a b c), chain.branches.map(&:name))
        end
      end

      def test_sort
        branches = {
          master: Branch.new(name: "master", parent_branch: nil, branch_point: nil),
          a: Branch.new(name: "a", parent_branch: "master", branch_point: nil),
          b: Branch.new(name: "b", parent_branch: "a", branch_point: nil),
          c: Branch.new(name: "c", parent_branch: "b", branch_point: nil),
        }

        unsorted = [branches[:master], branches[:a], branches[:c], branches[:b]]
        expected = [branches[:master], branches[:a], branches[:b], branches[:c]]

        assert_equal expected, Chain.sort_branches(unsorted)
      end
    end
  end
end
