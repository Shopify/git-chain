# frozen_string_literal: true
require "test_helper"

module GitChain
  module Commands
    class ListTest < Minitest::Test
      include RepositoryTestHelper

      def test_append
        with_test_repository("a-b-chain") do
          capture_io do
            Branch.new.call(%w(-c new a c))
          end

          out, _ = capture_io do
            List.new.call
          end

          expected = CLI::UI.fmt(<<~EOS)
              {{info:default}} {{reset:[{{cyan:master a b}}]}}
            {{yellow:*}} {{info:new}} {{reset:[{{cyan:a c}}]}}
          EOS
          assert_equal(expected, out)
        end
      end
    end
  end
end
