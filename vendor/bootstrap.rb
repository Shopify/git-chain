lib_path = File.expand_path("../../lib", __FILE__)
$LOAD_PATH.unshift(lib_path) unless $LOAD_PATH.include?(lib_path)

deps = %w(cli-ui cli-kit)
deps.each do |dep|
  vendor_path = File.expand_path("../deps/#{dep}/lib", __FILE__)
  $LOAD_PATH.unshift(vendor_path) unless $LOAD_PATH.include?(vendor_path)
end

require 'cli/ui'
require 'cli/kit'
