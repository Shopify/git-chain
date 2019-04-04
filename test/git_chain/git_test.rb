require 'test_helper'

module GitChain
  class GitTest < MiniTest::Test
    include RepositoryTestHelper

    def test_chains
      with_test_repository('a-b-c-chain') do
        assert_equal({ "a" => "default", "b" => "default", "c" => "default" }, Git.chains)
      end
    end
  end
end
