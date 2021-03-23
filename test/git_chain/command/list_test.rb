# frozen_string_literal: true
require "test_helper"

module GitChain
  module Commands
    class ListTest < MiniTest::Test
      include RepositoryTestHelper

      def test_append
        with_test_repository("a-b-chain") do
          Branch.new.call(%w(-c new a c))

          out, _ = capture_io do
            List.new.call
          end

          expected = CLI::UI.fmt(<<~EOS)
              {{blue:default}} [{{cyan:master}} -> {{cyan:a}} -> {{cyan:b}}]
            {{yellow:*}} {{blue:new}} [{{cyan:a}} -> {{cyan:c}}]
          EOS
          assert_equal(expected, out)
        end
      end
    end
  end
end
