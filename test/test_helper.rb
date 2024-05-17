# frozen_string_literal: true
require File.expand_path("../../vendor/bootstrap.rb", __FILE__)
require "git_chain"

require "minitest"
require "mocha/minitest"
require "minitest/autorun"
require "minitest/reporters"

Minitest::Reporters.use!
CLI::UI.enable_color = true

require "tmpdir"
require "fileutils"
require "tempfile"
require "open3"

module RepositoryTestHelper
  def with_test_repository(fixture_name = "a-b")
    previous_dir = Dir.pwd
    setup_script = File.expand_path("../../fixtures/#{fixture_name}.sh", __FILE__)

    Dir.mktmpdir("git-chain-rebase") do |dir|
      Dir.chdir(dir)
      _, err, stat = Open3.capture3(setup_script)
      raise "Cannot setup git repository using #{setup_script}: #{err}" unless stat.success?

      yield
    ensure
      Dir.chdir(previous_dir) if previous_dir
    end
  end
end

module Minitest
  class Test
    def capture_io(&block)
      cap = CLI::UI::StdoutRouter::Capture.new(with_frame_inset: true, &block)
      cap.run
      [cap.stdout, cap.stderr]
    end
  end
end
