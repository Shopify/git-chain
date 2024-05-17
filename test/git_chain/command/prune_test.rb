# frozen_string_literal: true
require "test_helper"

module GitChain
  module Commands
    class PruneTest < Minitest::Test
      include RepositoryTestHelper

      def test_clean_chain
        capture_io do
          with_test_repository("a-b-chain") do
            assert_equal(%w(master a b), Models::Chain.from_config("default").branch_names)

            Prune.new.call

            assert_equal(%w(master a b), Models::Chain.from_config("default").branch_names)
          end
        end
      end

      def test_rebase_merged
        capture_io do
          with_test_repository("a-b-chain") do
            assert_equal(%w(master a b), Models::Chain.from_config("default").branch_names)

            Rebase.new.call

            Git.exec("checkout", "master")
            Git.exec("merge", "a")

            Git.exec("checkout", "a")
            Rebase.new.call

            assert_equal(%w(master a b), Models::Chain.from_config("default").branch_names)

            Prune.new.call(["-d"])
            assert_equal(%w(master b), Models::Chain.from_config("default").branch_names)
          end
        end
      end
    end
  end
end
