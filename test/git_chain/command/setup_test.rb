require 'test_helper'

module GitChain
  class Command
    class SetupTest < MiniTest::Test
      include RepositoryTestHelper

      def test_chain_noop
        with_test_repository('a-b-c-chain') do
          chain = Model::Chain.from_config('default')
          Setup.new.call(%w(master a b c))
          assert_equal(chain, Model::Chain.from_config('default'))
        end
      end

      def test_setup
        with_test_repository('a-b-c') do
          before = Model::Chain.from_config('default')
          assert_equal("default", before.name)
          assert_empty(before.branches)

          Setup.new.call(%w(-n default master a b c))

          chain = Model::Chain.from_config('default')
          assert_equal(%w(master a b c), chain.branches.map(&:name))
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
