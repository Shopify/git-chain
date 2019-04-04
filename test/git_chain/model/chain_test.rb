require 'test_helper'

module GitChain
  class Model
    class ChainTest < MiniTest::Test
      include RepositoryTestHelper

      def test_from_config
        with_test_repository('a-b-c-chain') do
          chain = Chain.from_config('default')
          assert_equal('default', chain.name)
          assert_equal(%w(master a b c), chain.branches.map(&:name))
        end
      end

      def test_sort
        default_attributes = { chain_name: "default", branch_point: nil}
        branches = {
          master: Branch.new(default_attributes.merge(name: "master", parent_branch: nil)),
          a: Branch.new(default_attributes.merge(name: "a", parent_branch: "master")),
          b: Branch.new(default_attributes.merge(name: "b", parent_branch: "a")),
          c: Branch.new(default_attributes.merge(name: "c", parent_branch: "b")),
        }

        unsorted = [branches[:master], branches[:a], branches[:c], branches[:b]]
        expected = [branches[:master], branches[:a], branches[:b], branches[:c]]

        assert_equal expected, Chain.sort_branches(unsorted)
      end
    end
  end
end
