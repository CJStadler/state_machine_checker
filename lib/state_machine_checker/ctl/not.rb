require_relative "unary_operator"

module StateMachineChecker
  module CTL
    # The logical negation of a formula.
    class Not < UnaryOperator
      # States of the model that satisfy all sub-formulae.
      #
      # @param [LabeledMachine] model
      # @return [Set<Symbol>]
      def satisfying_states(model)
        model.states.to_set - subformula.satisfying_states(model)
      end
    end
  end
end
