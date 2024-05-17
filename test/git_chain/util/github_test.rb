# frozen_string_literal: true
require "test_helper"

module GitChain
  module Util
    class GithubTest < Minitest::Test
      def test_parse_url
        %w(
          git@github.com:Shopify/git-chain.git
          ssh://git@github.com:Shopify/git-chain.git
          https://github.com/Shopify/git-chain.git
          http://github.com/Shopify/git-chain.git
        ).each do |input|
          url, org, repo = Github.parse_url(input)
          assert_equal("https://github.com/Shopify/git-chain", url)
          assert_equal("Shopify", org)
          assert_equal("git-chain", repo)
        end
      end
    end
  end
end
