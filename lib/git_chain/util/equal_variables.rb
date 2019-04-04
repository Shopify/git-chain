module GitChain
  module Util
    module EqualVariables
      alias_method :eql?, :==

      def ==(other)
        other.class == self.class && other.state == state
      end

      def hash
        state.hash
      end

      protected

      def state
        instance_variables.map(&method(:instance_variable_get))
      end
    end
  end
end
