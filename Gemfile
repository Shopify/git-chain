# frozen_string_literal: true
source "https://rubygems.org"

ruby ">= 2.6"

# None of these can actually be used in a development copy of dev
# They are all for CI and tests
# `dev` uses no gems

group :development, :test do
  gem "rubocop", "~> 1.13.0"
  gem "rubocop-performance"
  gem "rubocop-minitest"
  gem "rubocop-rake"
  gem "rubocop-shopify", "~> 2.0.1", require: false
  gem "rake"
end

group :test do
  gem "mocha", require: false
  gem "minitest", ">= 5.0.0", require: false
  gem "minitest-reporters", require: false
end
