require File.expand_path('../vendor/bootstrap.rb', __FILE__)

require 'rake'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs += %w(test)
  t.test_files = FileList['test/**/*_test.rb']
  t.warning = false
end
