module GitChain
  class Model
    include Util::EqualVariables

    autoload :Branch, "git_chain/model/branch"
    autoload :Chain, "git_chain/model/Chain"
  end
end
