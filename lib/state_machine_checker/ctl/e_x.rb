require_relative "unary_operator"

module StateMachineChecker
  module CTL
    # The existential next operator.
    class EX < UnaryOperator
      # The states which have a transition directly to a state which satisfies
      # the sub-formula.
      #
      # @param [LabeledMachine] model
      # @return [Set<Symbol>]
      def satisfying_states(model)
        all = subformula
          .satisfying_states(model)
          .flat_map { |s| model.previous_states(s) }

        Set.new(all)
      end
    end
  end
end
