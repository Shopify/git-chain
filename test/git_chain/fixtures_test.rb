# frozen_string_literal: true
require "test_helper"

module GitChain
  class FixturesTest < Minitest::Test
    include RepositoryTestHelper

    def test_with_test_repository
      with_test_repository do
        assert(File.exist?(".git"))
        assert_match(/master.2/, Git.exec("log", "--oneline", "@^..@"))
      end
    end
  end
end
