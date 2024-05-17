# frozen_string_literal: true
require "test_helper"

module GitChain
  module Commands
    class RebaseTest < Minitest::Test
      include RepositoryTestHelper

      def test_rebasing_a_clean_chain
        capture_io do
          with_test_repository("a-b-chain") do
            Rebase.new.call

            assert_equal(Git.rev_parse("master"), Git.merge_base("master", "a"))
            assert_equal(Git.rev_parse("a"), Git.merge_base("a", "b"))

            assert_equal(Git.rev_parse("master"), Git.get_config("branch.a.branchPoint"))
            assert_equal(Git.rev_parse("a"), Git.get_config("branch.b.branchPoint"))
          end
        end
      end

      def test_conflict
        capture_io do
          with_test_repository("a-b-conflicts") do
            assert_raises(AbortSilent) do
              Rebase.new.run(chain_name: "default")
            end

            Git.exec("add", ".")
            Git.exec("commit", "-m", "message")
            Git.exec("rebase", "--continue")

            Rebase.new.call

            assert_equal(Git.rev_parse("master"), Git.merge_base("master", "a"))
            assert_equal(Git.rev_parse("a"), Git.merge_base("a", "b"))

            assert_equal(Git.rev_parse("master"), Git.get_config("branch.a.branchPoint"))
            assert_equal(Git.rev_parse("a"), Git.get_config("branch.b.branchPoint"))
            assert_equal(Git.rev_parse("master"), Git.merge_base("master", "a"))
            assert_equal(Git.rev_parse("a"), Git.merge_base("a", "b"))

            assert_equal(Git.rev_parse("master"), Git.get_config("branch.a.branchPoint"))
            assert_equal(Git.rev_parse("a"), Git.get_config("branch.b.branchPoint"))
          end
        end
      end

      def test_rebase_in_progress
        capture_io do
          with_test_repository("a-b-conflicts") do
            %x(git rebase --onto a b^ b)
            exception = assert_raises(Abort) do
              Rebase.new.call
            end

            assert_match(/rebase is in progress/, exception.message)
          end
        end
      end

      def test_rebase_merged
        capture_io do
          with_test_repository("a-b-chain") do
            Rebase.new.call

            Git.exec("checkout", "master")
            Git.exec("merge", "a")

            assert_equal(Git.rev_parse("master"), Git.rev_parse("a"))

            Git.exec("checkout", "a")
            Rebase.new.call

            assert_equal(Git.rev_parse("master"), Git.rev_parse("a"))
          end
        end
      end

      def test_rebase_moved
        capture_io do
          with_test_repository("a-b-chain") do
            Rebase.new.call

            a = Git.rev_parse("a")

            Git.exec("checkout", "a")
            Git.exec("commit", "-m", "message", "--allow-empty")
            new_a = Git.rev_parse("a")

            Git.exec("rebase", "--keep-empty", "--onto", "a", a, "b")
            assert_equal(new_a, Git.rev_parse("b~2"))

            Rebase.new.call
            assert_equal(new_a, Git.rev_parse("b~2"))
          end
        end
      end
    end
  end
end
