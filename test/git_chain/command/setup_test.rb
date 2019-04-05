require 'test_helper'

module GitChain
  module Commands
    class SetupTest < MiniTest::Test
      include RepositoryTestHelper

      def test_chain_noop
        with_test_repository('a-b-chain') do
          chain = Models::Chain.from_config('default')
          Setup.new.call(%w(master a b))
          assert_equal(chain, Models::Chain.from_config('default'))
        end
      end

      def test_orphan
        with_test_repository('orphan') do
          err = assert_raises(AbortError) do
            Setup.new.call(%w(a b))
          end
          assert_equal("Branches are not all connected", err.message)
        end
      end

      def test_setup
        with_test_repository('a-b-c') do
          before = Models::Chain.from_config('default')
          assert_equal("default", before.name)
          assert_empty(before.branches)

          Setup.new.call(%w(--chain default master a b c))

          chain = Models::Chain.from_config('default')
          assert_equal(%w(master a b c), chain.branch_names)
          chain.branches.each_with_index do |b, i|
            if i == 0
              assert_nil(b.parent_branch)
              assert_nil(b.branch_point)
            else
              assert_equal(chain.branches[i - 1].name, b.parent_branch)
            end
          end
        end
      end
    end
  end
end
