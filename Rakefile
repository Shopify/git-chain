require 'rake'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs += %w(test)
  t.test_files = FileList['test/**/test*.rb']
end
