module GitChain
  module Models
    class Chain
      attr_reader :name, :branches

      def initialize(name:, branches:)
        @name = name
        @branches = branches
      end
    end
  end
end