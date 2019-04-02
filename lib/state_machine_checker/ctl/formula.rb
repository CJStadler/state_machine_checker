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
    end
  end
end
