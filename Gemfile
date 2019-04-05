source "https://rubygems.org"

ruby '2.3.7'

# None of these can actually be used in a development copy of dev
# They are all for CI and tests
# `dev` uses no gems

group :development, :test do
  gem 'rubocop', '~> 0.65.0'
  gem 'shopify-cops', require: false, source: 'https://packages.shopify.io/shopify/gems'
  gem 'rake'
end

group :test do
  gem 'mocha', require: false
  gem 'minitest', '>= 5.0.0', require: false
  gem 'minitest-reporters', require: false
end
