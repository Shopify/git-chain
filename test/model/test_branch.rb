require '../helper'

module GitChain
  class Model
    class TestBranch < MiniTest::Test
      include RepositoryTestHelper

      def test_from_config
        with_test_repository('a-b-c-chain') do
          branch = Branch.from_config('a')
          assert_equal('a', branch.name)
          assert_equal('master', branch.parent_branch)
        end
      end
    end
  end
end
