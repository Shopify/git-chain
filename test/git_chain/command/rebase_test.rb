require 'test_helper'

module GitChain
  module Commands
    class RebaseTest < MiniTest::Test
      include RepositoryTestHelper

      def test_rebasing_a_clean_chain
        with_test_repository("a-b-chain") do
          Rebase.new.call

          assert_equal(Git.rev_parse("master"), Git.merge_base("master", "a"))
          assert_equal(Git.rev_parse("a"), Git.merge_base("a", "b"))

          assert_equal(Git.rev_parse("master"), Git.get_config("branch.a.branchPoint"))
          assert_equal(Git.rev_parse("a"), Git.get_config("branch.b.branchPoint"))
        end
      end

      def test_conflict
        with_test_repository("a-b-conflicts") do
          Rebase.new.run(chain_name: "default")

          Git.exec('add', '.')
          Git.exec('commit', '-m', 'message')
          Git.exec('rebase', '--continue')

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

      def test_rebase_in_progress
        with_test_repository("a-b-conflicts") do
          %x(git rebase --onto a b^ b)
          exception = assert_raises(AbortError) do
            Rebase.new.call
          end

          assert_match(/rebase is in progress/, exception.message)
        end
      end

      def test_rebase_merged
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
  end
end
