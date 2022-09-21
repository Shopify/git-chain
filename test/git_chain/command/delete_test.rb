# frozen_string_literal: true
require "test_helper"

module GitChain
  module Commands
    class DeleteTest < MiniTest::Test
      include RepositoryTestHelper

      def test_deleting_a_clean_chain
        capture_io do
          with_test_repository("a-b-chain") do
            assert_equal(%w(master a b), Models::Chain.from_config("default").branch_names)

            Delete.new.call

            assert(Models::Chain.from_config("default").empty?)
          end
        end
      end

      def test_rebase_in_progress
        capture_io do
          with_test_repository("a-b-conflicts") do
            %x(git rebase --onto a b^ b)
            exception = assert_raises(Abort) do
              Delete.new.call
            end

            assert_match(/rebase is in progress/, exception.message)
          end
        end
      end
    end
  end
end
