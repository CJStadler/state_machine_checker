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
        substates = subformula.satisfying_states(model)
        substates.each_with_object(Set.new) { |state, set|
          set.merge(model.previous_states(state))
        }
      end
    end
  end
end
