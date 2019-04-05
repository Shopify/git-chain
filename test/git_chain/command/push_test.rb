require 'test_helper'

module GitChain
  module Commands
    class PushTest < MiniTest::Test
      include RepositoryTestHelper

      def test_push_nothing
        with_remote_test_repository('a-b-c-chain') do |remote_repo|
          assert_empty(Git.branches(dir: remote_repo))

          err = assert_raises(AbortError) do
            Push.new.call
          end
          assert_equal("Nothing to push", err.message)
        end
      end

      def test_push_upstream
        with_remote_test_repository('a-b-c-chain') do |remote_repo|
          assert_empty(Git.branches(dir: remote_repo))

          Push.new.call(['-u'])
          assert_equal(%w(master a b c).sort, Git.branches(dir: remote_repo).sort)

          assert_equal('test/master', Git.upstream_branch(branch: 'master'))
        end
      end

      def test_push_force_upstream
        with_remote_test_repository('a-b-c-chain') do |remote_repo|
          assert_empty(Git.branches(dir: remote_repo))

          Push.new.call(['-u'])
          assert_equal(%w(master a b c).sort, Git.branches(dir: remote_repo).sort)

          Git.exec('checkout', 'c')
          Git.exec('commit', '--amend', '--allow-empty', '-m', 'test')

          err = assert_raises(AbortError) do
            Push.new.call
          end
          assert_equal("git push failed", err.message)

          Push.new.call(['-f'])
        end
      end

      private

      def with_remote_test_repository(fixture_name, remote: 'test')
        Dir.mktmpdir('git-chain-rebase') do |dir|
          Git.exec('init', '--bare', dir)

          with_test_repository(fixture_name) do
            Git.exec('remote', 'add', remote, dir)
            yield(dir)
          end
        end
      end
    end
  end
end
