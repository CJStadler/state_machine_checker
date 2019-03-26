require_relative "and"
require_relative "atom"
require_relative "e_f"
require_relative "e_x"
require_relative "not"
require_relative "or"

module StateMachineChecker
  module CTL
    module API
      def EF(subformula) # rubocop:disable Naming/MethodName
        CTL::EF.new(subformula)
      end

      def EX(subformula) # rubocop:disable Naming/MethodName
        CTL::EX.new(subformula)
      end

      def and(*subformulae)
        And.new(subformulae)
      end

      def atom(method_name_or_fn)
        Atom.new(method_name_or_fn)
      end

      def not(subformula)
        Not.new(subformula)
      end

      def or(*subformulae)
        Or.new(subformulae)
      end
    end
  end
end
