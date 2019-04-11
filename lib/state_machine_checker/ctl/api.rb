require_relative "and"
require_relative "atom"
require_relative "e_f"
require_relative "e_x"
require_relative "e_g"
require_relative "e_u"
require_relative "not"
require_relative "or"

module StateMachineChecker
  module CTL
    module API
      def atom(method_name_or_fn)
        Atom.new(method_name_or_fn)
      end

      def EF(subformula) # rubocop:disable Naming/MethodName
        CTL::EF.new(subformula)
      end

      def EX(subformula) # rubocop:disable Naming/MethodName
        CTL::EX.new(subformula)
      end

      def EG(subformula) # rubocop:disable Naming/MethodName
        CTL::EG.new(subformula)
      end

      def AF(subformula) # rubocop:disable Naming/MethodName
        CTL::EG.new(subformula.not).not
      end

      def AX(subformula) # rubocop:disable Naming/MethodName
        CTL::EX.new(subformula.not).not
      end

      def AG(subformula) # rubocop:disable Naming/MethodName
        CTL::EF.new(subformula.not).not
      end
    end
  end
end
