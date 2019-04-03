lib_path = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib_path) unless $LOAD_PATH.include?(lib_path)

require 'rake'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs += %w(test)
  t.test_files = FileList['test/**/*_test.rb']
end
