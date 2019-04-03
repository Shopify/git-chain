module GitChain
  class Model
    class Chain < Model
      attr_reader :name, :branches

      def initialize(name:, branches:)
        @name = name
        @branches = branches
      end
    end
  end
end
