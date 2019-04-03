module GitChain
  module Models
    class Branch
      attr_reader :name, :parent, :point

      def initialize(name:, parent:, point:)
        @name = name
        @parent = parent
        @point = point
      end
    end
  end
end