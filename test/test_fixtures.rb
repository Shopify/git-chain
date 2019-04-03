require 'helper'

class TestFixtures < MiniTest::Test
  include RepositoryTestHelper

  def test_with_test_repository
    with_test_repository do
      assert File.exists?('.git')
      assert_match /master.2/, `git log --oneline @^..@`
    end
  end
end
