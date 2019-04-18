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
        self.and(atom_or_formula(other_subformula)).or(Not.new(self))
      end

      # The existential until operator.
      def EU(end_formula) # rubocop:disable Naming/MethodName
        EU.new(self, atom_or_formula(end_formula))
      end

      def AU(end_formula) # rubocop:disable Naming/MethodName
        end_formula = atom_or_formula(end_formula)
        Not.new(Not.new(end_formula).EU(Not.new(self.or(end_formula)))
          .or(EG.new(Not.new(end_formula))))
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
