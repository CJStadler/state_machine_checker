require_relative "and"
require_relative "atom"
require_relative "a_x"
require_relative "a_f"
require_relative "a_g"
require_relative "a_u"
require_relative "e_f"
require_relative "e_x"
require_relative "e_g"
require_relative "e_u"
require_relative "not"
require_relative "or"
require_relative "implication"

module StateMachineChecker
  module CTL
    module API
      def atom(method_name_or_fn)
        Atom.new(method_name_or_fn)
      end

      def neg(subformula)
        Not.new(atom_or_formula(subformula))
      end

      def EF(subformula) # rubocop:disable Naming/MethodName
        CTL::EF.new(atom_or_formula(subformula))
      end

      def EX(subformula) # rubocop:disable Naming/MethodName
        CTL::EX.new(atom_or_formula(subformula))
      end

      def EG(subformula) # rubocop:disable Naming/MethodName
        CTL::EG.new(atom_or_formula(subformula))
      end

      def AF(subformula) # rubocop:disable Naming/MethodName
        CTL::AF.new(atom_or_formula(subformula))
      end

      def AX(subformula) # rubocop:disable Naming/MethodName
        CTL::AX.new(atom_or_formula(subformula))
      end

      def AG(subformula) # rubocop:disable Naming/MethodName
        CTL::AG.new(atom_or_formula(subformula))
      end

      private

      def atom_or_formula(subformula)
        if subformula.is_a? Formula
          subformula
        else
          atom(subformula)
        end
      end
    end
  end
end
