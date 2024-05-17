# frozen_string_literal: true
require "test_helper"

module GitChain
  class GitTest < Minitest::Test
    include RepositoryTestHelper

    def test_chains
      with_test_repository("a-b-chain") do
        assert_equal({ "a" => "default", "b" => "default" }, Git.chains)
      end
    end
  end
end
