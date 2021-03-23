# frozen_string_literal: true
module GitChain
  module Models
    class Model
      include Util::EqualVariables
      include Util::Output

      def inspect
        "<#{self.class.name.split("::").last} #{state.select { |_, v| v }}>"
      end
    end
  end
end
