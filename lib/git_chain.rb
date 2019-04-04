require 'cli/ui'
require 'cli/kit'

module GitChain
  extend CLI::Kit::Autocall

  TOOL_NAME        = "git-chain"
  CONFIG_HOME      = File.expand_path(ENV.fetch('XDG_CONFIG_HOME', '~/.config'))
  TOOL_CONFIG_PATH = File.join(CONFIG_HOME, TOOL_NAME)
  DEBUG_LOG_FILE   = File.join(TOOL_CONFIG_PATH, 'logs', 'debug.log')

  autocall(:Logger) { CLI::Kit::Logger.new(debug_log_file: DEBUG_LOG_FILE) }

  autoload :Commands, 'git_chain/commands'
  autoload :EntryPoint, 'git_chain/entry_point'
  autoload :Git, 'git_chain/git'
  autoload :Models, 'git_chain/models'
  autoload :Options, 'git_chain/options'
  autoload :Util, 'git_chain/util'

  AbortSilentError = Class.new(RuntimeError)
  AbortError = Class.new(RuntimeError)
end
