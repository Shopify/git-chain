# frozen_string_literal: true
require "test_helper"

module GitChain
  class EntryPointTest < MiniTest::Test
    def test_commands
      refute_nil(EntryPoint.commands["setup"])
    end
  end
end
