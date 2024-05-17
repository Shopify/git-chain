# frozen_string_literal: true
require "test_helper"

module GitChain
  module Commands
    class BranchTest < Minitest::Test
      include RepositoryTestHelper

      def test_append
        capture_io do
          with_test_repository("a-b-chain") do
            chain = Models::Chain.from_config("default")
            assert_equal(%w(master a b), chain.branch_names)

            Branch.new.call(%w(c))

            chain = Models::Chain.from_config("default")
            assert_equal(%w(master a b c), chain.branch_names)

            assert_equal("b", chain.branches[3].parent_branch)
            assert_equal(Git.rev_parse("b"), chain.branches[3].branch_point)
          end
        end
      end

      def test_insert_chain
        capture_io do
          with_test_repository("a-b-chain") do
            chain = Models::Chain.from_config("default")
            assert_equal(%w(master a b), chain.branch_names)
            b_branch_point = chain.branches.last.branch_point

            Branch.new.call(%w(a c --insert))

            chain = Models::Chain.from_config("default")
            assert_equal(%w(master a c b), chain.branch_names)

            c = chain.branches[2]
            assert_equal("a", c.parent_branch)
            assert_equal(Git.rev_parse("a"), c.branch_point)

            b = chain.branches[3]
            assert_equal("c", b.parent_branch)
            assert_equal(b_branch_point, b.branch_point) # Has not changed yet
          end
        end
      end

      def test_new_middle_of_chain
        capture_io do
          with_test_repository("a-b-chain") do
            chain = Models::Chain.from_config("default")
            assert_equal(%w(master a b), chain.branch_names)

            Branch.new.call(%w(a c))

            chain = Models::Chain.from_config("c")
            assert_equal(%w(a c), chain.branch_names)

            c = chain.branches[1]
            assert_equal("a", c.parent_branch)
            assert_equal(Git.rev_parse("a"), c.branch_point)
          end
        end
      end

      def test_new_end_of_chain
        capture_io do
          with_test_repository("a-b-chain") do
            chain = Models::Chain.from_config("default")
            assert_equal(%w(master a b), chain.branch_names)

            Branch.new.call(%w(c --new))

            chain = Models::Chain.from_config("c")
            assert_equal(%w(b c), chain.branch_names)

            assert_equal("b", chain.branches[1].parent_branch)
            assert_equal(Git.rev_parse("b"), chain.branches[1].branch_point)
          end
        end
      end

      def test_branch_outside_of_chain
        capture_io do
          with_test_repository("a-b-chain") do
            chain = Models::Chain.from_config("default")
            assert_equal(%w(master a b), chain.branch_names)

            Git.exec("checkout", "a", "-b", "c")
            Git.exec("commit", "--allow-empty", "-m", "c")

            Branch.new.call(%w(c d))

            chain = Models::Chain.from_config("default")
            assert_equal(%w(master a b), chain.branch_names)

            chain = Models::Chain.from_config("d")
            assert_equal(%w(c d), chain.branch_names)
          end
        end
      end
    end
  end
end
