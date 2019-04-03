module GitChain
  autoload :Command, 'git_chain/command'
  autoload :EntryPoint, 'git_chain/entry_point'
  autoload :Git, 'git_chain/git'
  autoload :Option, 'git_chain/option'

  AbortSilentError = Class.new(RuntimeError)
  AbortError = Class.new(RuntimeError)
end
