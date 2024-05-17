# frozen_string_literal: true
require "test_helper"

module GitChain
  module Commands
    class SetupTest < Minitest::Test
      include RepositoryTestHelper

      def test_chain_noop
        capture_io do
          with_test_repository("a-b-chain") do
            chain = Models::Chain.from_config("default")
            Setup.new.call(%w(master a b))
            assert_equal(chain, Models::Chain.from_config("default"))
          end
        end
      end

      def test_orphan
        capture_io do
          with_test_repository("orphan") do
            err = assert_raises(Abort) do
              Setup.new.call(%w(a b))
            end
            assert_equal("Branches are not all connected", err.message)
          end
        end
      end

      def test_branches_dupes
        capture_io do
          with_test_repository("a-b") do
            [%w(b b), %w(a b b)].each do |branches|
              err = assert_raises(Abort) do
                Setup.new.call(branches)
              end

              assert_equal("b cannot be part of the chain multiple times", err.message)
            end
          end
        end
      end

      def test_setup
        capture_io do
          with_test_repository("a-b") do
            before = Models::Chain.from_config("default")
            assert_equal("default", before.name)
            assert_empty(before.branches)

            Setup.new.call(%w(--chain default master a b))

            chain = Models::Chain.from_config("default")
            assert_equal(%w(master a b), chain.branch_names)
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
end
