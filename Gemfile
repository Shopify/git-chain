source "https://rubygems.org"

ruby '2.7.2'

# None of these can actually be used in a development copy of dev
# They are all for CI and tests
# `dev` uses no gems

group :development, :test do
  gem 'rubocop'
  gem 'rubocop-performance'
  gem 'rake'
end

group :test do
  gem 'mocha', require: false
  gem 'minitest', '>= 5.0.0', require: false
  gem 'minitest-reporters', require: false
end
