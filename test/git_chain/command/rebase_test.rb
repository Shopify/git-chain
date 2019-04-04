require 'test_helper'

module GitChain
  class RebaseTest < MiniTest::Test
    include RepositoryTestHelper

    def test_rebasing_a_clean_chain
      with_test_repository("a-b-c-chain") do
        Command::Rebase.new.call

        assert_equal Git.rev_parse("master"), Git.merge_base("master", "a")
        assert_equal Git.rev_parse("a"), Git.merge_base("a", "b")
        assert_equal Git.rev_parse("b"), Git.merge_base("b", "c")

        assert_equal Git.rev_parse("master"), Git.get_config("branch.a.branchPoint")
        assert_equal Git.rev_parse("a"), Git.get_config("branch.b.branchPoint")
        assert_equal Git.rev_parse("b"), Git.get_config("branch.c.branchPoint")
      end
    end

    def test_conflict
      with_test_repository("a-b-c-conflicts") do
        Command::Rebase.new.call
      end
    end
  end
end
