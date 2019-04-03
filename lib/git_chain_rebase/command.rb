module GitChainRebase
  class Command
    def self.command_name
      name.split('::')
        .last
        .gsub(/([A-Z]+)([A-Z][a-z])/, '\1-\2')
        .gsub(/([a-z\d])([A-Z])/, '\1-\2')
        .downcase
    end
  end
end
