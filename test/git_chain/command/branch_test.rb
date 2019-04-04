require 'test_helper'

module GitChain
  class Command
    class BranchTest < MiniTest::Test
      include RepositoryTestHelper

      def test_add_to_end_of_chain
        with_test_repository('a-b-c-chain') do
          chain = Model::Chain.from_config('default')
          assert_equal(%w(master a b c), chain.branch_names)

          Branch.new.call(%w(d))

          chain = Model::Chain.from_config('default')
          assert_equal(%w(master a b c d), chain.branch_names)

          assert_equal('c', chain.branches[4].parent_branch)
          assert_equal(Git.rev_parse('c'), chain.branches[4].branch_point)
        end
      end

      def test_add_to_middle_of_chain
        with_test_repository('a-b-c-chain') do
          chain = Model::Chain.from_config('default')
          assert_equal(%w(master a b c), chain.branch_names)
          c_branch_point = chain.branches.last.branch_point

          Branch.new.call(%w(b d))

          chain = Model::Chain.from_config('default')
          assert_equal(%w(master a b d c), chain.branch_names)

          d = chain.branches[3]
          assert_equal('b', d.parent_branch)
          assert_equal(Git.rev_parse('b'), d.branch_point)

          c = chain.branches[4]
          assert_equal('d', c.parent_branch)
          assert_equal(c_branch_point, c.branch_point) # As not changed yet
        end
      end

      def test_branch_outside_of_chain
        with_test_repository('a-b-c-chain') do
          chain = Model::Chain.from_config('default')
          assert_equal(%w(master a b c), chain.branch_names)

          Git.exec('checkout', 'b', '-b', 'd')
          Git.exec('commit', '--allow-empty', '-m', 'd')

          Branch.new.call(%w(d e))

          chain = Model::Chain.from_config('default')
          assert_equal(%w(master a b c), chain.branch_names)

          chain = Model::Chain.from_config('e')
          assert_equal(%w(d e), chain.branch_names)
        end
      end
    end
  end
end
