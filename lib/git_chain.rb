module GitChain
  autoload :Commands, 'git_chain/commands'
  autoload :EntryPoint, 'git_chain/entry_point'
  autoload :Git, 'git_chain/git'
  autoload :Models, 'git_chain/models'
  autoload :Options, 'git_chain/options'
  autoload :Util, 'git_chain/util'

  AbortSilentError = Class.new(RuntimeError)
  AbortError = Class.new(RuntimeError)
end
