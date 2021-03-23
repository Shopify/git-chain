# frozen_string_literal: true
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
        instance_variables.map { |v| [v, instance_variable_get(v)] }.to_h
      end
    end
  end
end
