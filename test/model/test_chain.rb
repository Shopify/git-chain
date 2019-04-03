require '../helper'

module GitChain
  class Model
    class TestChain < MiniTest::Test
      include RepositoryTestHelper

      def test_from_config
        with_test_repository('a-b-c-chain') do
          chain = Chain.from_config('default')
          assert_equal('default', chain.name)
          # TODO, change to ordered
          require 'set'
          assert_equal(Set.new(%w(master a b c)), Set.new(chain.branches.map(&:name)))
        end
      end
    end
  end
end
