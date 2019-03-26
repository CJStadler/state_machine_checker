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
        substates = subformula.satisfying_states(model)
        substates.each_with_object(Set.new) { |state, set|
          set.merge(model.predecessor_states(state))
        }.merge(substates)
      end
    end
  end
end
