# frozen_string_literal: true
require "test_helper"

module GitChain
  module Commands
    class PushTest < Minitest::Test
      include RepositoryTestHelper

      def test_push_nothing
        capture_io do
          with_remote_test_repository("a-b-chain") do |remote_repo|
            assert_empty(Git.branches(dir: remote_repo))

            err = assert_raises(Abort) do
              Push.new.call
            end
            assert_equal("Nothing to push", err.message)
          end
        end
      end

      def test_push_upstream
        capture_io do
          with_remote_test_repository("a-b-chain") do |remote_repo|
            assert_empty(Git.branches(dir: remote_repo))
            assert_nil(Git.remote_name(branch: "a"))

            Push.new.call(["-u"])
            assert_equal(%w(a b).sort, Git.branches(dir: remote_repo).sort)

            assert_equal("test/a", Git.push_branch(branch: "a"))
            assert_equal("test", Git.remote_name(branch: "a"))
            assert_equal(remote_repo, Git.remote_url(branch: "a"))
          end
        end
      end

      def test_push_force_upstream
        capture_io do
          with_remote_test_repository("a-b-chain") do |remote_repo|
            assert_empty(Git.branches(dir: remote_repo))

            Push.new.call(["-u"])
            assert_equal(%w(a b).sort, Git.branches(dir: remote_repo).sort)

            Git.exec("checkout", "b")
            Git.exec("commit", "--amend", "--allow-empty", "-m", "test")

            err = assert_raises(Abort) do
              Push.new.call
            end
            assert_equal("git push failed", err.message)

            Push.new.call(["-f"])
          end
        end
      end

      private

      def with_remote_test_repository(fixture_name, remote: "test")
        Dir.mktmpdir("git-chain-rebase") do |dir|
          Git.exec("init", "--bare", dir)

          with_test_repository(fixture_name) do
            Git.exec("remote", "add", remote, dir)
            yield(dir)
          end
        end
      end
    end
  end
end
