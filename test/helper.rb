lib_path = File.expand_path("../../lib", __FILE__)
$LOAD_PATH.unshift(lib_path) unless $LOAD_PATH.include?(lib_path)

require 'git_chain'

require 'minitest'
require 'mocha/mini_test'
require "minitest/autorun"

require 'tmpdir'
require 'fileutils'
require 'tempfile'

module RepositoryTestHelper
  def with_test_repository(fixture_name='a-b-c')
    previous_dir = Dir.pwd
    setup_script = File.absolute_path("fixtures/#{fixture_name}.sh")

    Dir.mktmpdir('git-chain-rebase') do |dir|
      Dir.chdir(dir)
      setup_ok = system(setup_script)
      raise "Cannot setup git repository using #{setup_script}" unless setup_ok

      yield
    ensure
      Dir.chdir(previous_dir) if previous_dir
    end
  end
end