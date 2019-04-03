lib_path = File.expand_path("../../lib", __FILE__)
$LOAD_PATH.unshift(lib_path) unless $LOAD_PATH.include?(lib_path)

require 'git_chain'

require 'minitest'
require 'mocha/mini_test'
require "minitest/autorun"

require 'tmpdir'
require 'fileutils'
require 'tempfile'
