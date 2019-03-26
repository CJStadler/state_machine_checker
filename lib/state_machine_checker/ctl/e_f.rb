require_relative "unary_operator"

module StateMachineChecker
  module CTL
    # The existential eventually operator.
    class EF < UnaryOperator
      # The states from which a state which satisfies the sub-formula is
      # reachable.
      #
      # @param [LabeledMachine] model
      # @return [Set<Symbol>]
      def satisfying_states(model)
        subformula
          .satisfying_states(model)
          .flat_map { |s| model.predecessor_states(s) }
          .to_set
      end
    end
  end
end
