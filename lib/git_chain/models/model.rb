module GitChain
  module Models
    class Model
      include Util::EqualVariables

      def inspect
        "<#{self.class.name.split('::').last} #{state.compact}>"
      end
    end
  end
end
