module StateMachineChecker
  module CTL
    # Abstract base class for CTL formulae.
    class Formula
      # The logical conjuction of this formula with others.
      def and(*other_subformulae)
        And.new(other_subformulae << self)
      end

      # The logical negation of this formula.
      def not
        Not.new(self)
      end

      # The logical disjunction of this formula with others.
      def or(*other_subformulae)
        Or.new(other_subformulae << self)
      end

      # The existential until operator.
      def EU(end_formula) # rubocop:disable Naming/MethodName
        EU.new(self, end_formula)
      end

      def AU(end_formula) # rubocop:disable Naming/MethodName
        end_formula.not.EU(self.or(end_formula).not)
          .or(EG.new(end_formula.not))
          .not
      end
    end
  end
end
