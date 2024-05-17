# frozen_string_literal: true
require "test_helper"

module GitChain
  module Models
    class ChainTest < Minitest::Test
      include RepositoryTestHelper

      def test_from_config
        with_test_repository("a-b-chain") do
          chain = Chain.from_config("default")
          assert_equal("default", chain.name)
          assert_equal(%w(master a b), chain.branch_names)
        end
      end

      def test_sort
        master = Branch.new(name: "master")
        a = Branch.new(name: "a", parent_branch: "master")
        b = Branch.new(name: "b", parent_branch: "a")

        expected = [master, a, b]

        assert_equal(expected, Chain.sort_branches(expected))
        assert_equal(expected, Chain.sort_branches([master, b, a]))
        assert_equal(expected, Chain.sort_branches([a, master, b]))
      end
    end
  end
end
