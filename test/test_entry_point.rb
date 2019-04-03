require 'helper'

module GitChainRebase
  class TestEntryPoint < MiniTest::Test
    def test_commands
      refute_nil(EntryPoint.commands['setup'])
    end
  end
end
