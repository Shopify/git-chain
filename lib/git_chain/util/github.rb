# frozen_string_literal: true
module GitChain
  module Util
    module Github
      class << self
        def parse_url(url)
          # matches git@github.com:organization/project.git, https://github.com/organization/project.git
          parsed_arg = url.match(
            %r{
              ^(?:(?:ssh://)?git@|https?://|git://) # git, http, https, and ssh protocols
              github\.com[/:]                       # domain with either / (http) or : (ssh) separator
              (.+?)/(.+?)(?:\.git)?$                # capture account/org and project; '.git' optional
            }x
          )
          raise(ArgumentError, "invalid Github URL") unless parsed_arg

          org = parsed_arg[1]
          project = parsed_arg[2]
          [url(org, project), org, project]
        end

        def url(org, project)
          "https://github.com/#{org}/#{project}"
        end
      end
    end
  end
end
