module StateMachineChecker
  module CTL
    # Abstract base class for CTL formulae.
    class Formula
      # The logical conjuction of this formula with others.
      def and(*other_subformulae)
        other_subformulae.map! { |f| atom_or_formula(f) }
        And.new(other_subformulae << self)
      end

      # The logical disjunction of this formula with others.
      def or(*other_subformulae)
        other_subformulae.map! { |f| atom_or_formula(f) }
        Or.new(other_subformulae << self)
      end

      # Logical implication
      def implies(other_subformula)
        Implication.new(self, atom_or_formula(other_subformula))
      end

      # The existential until operator.
      def EU(end_formula) # rubocop:disable Naming/MethodName
        EU.new(self, atom_or_formula(end_formula))
      end

      def AU(end_formula) # rubocop:disable Naming/MethodName
        AU.new(self, atom_or_formula(end_formula))
      end

      private

      def atom_or_formula(subformula)
        if subformula.is_a? Formula
          subformula
        else
          Atom.new(subformula)
        end
      end
    end
  end
end
