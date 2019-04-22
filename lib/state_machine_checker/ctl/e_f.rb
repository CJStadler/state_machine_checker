require_relative "unary_operator"

module StateMachineChecker
  module CTL
    # The existential eventually operator.
    class EF < UnaryOperator
      # Check which states of the model have as a successor a state
      # satisfying the subformula.
      #
      # @param [LabeledMachine] model
      # @return [CheckResult]
      def check(model)
        subresult = subformula.check(model)
        result = subresult.to_h
        model.states.each do |state|
          sub_state_result = subresult.for_state(state)

          if sub_state_result.satisfied? # Mark predecessors as satisfied.
            model.traverse(state, reverse: true) do |s, transitions|
              witness = transitions + sub_state_result.witness
              result[s] = StateResult.new(true, witness)
            end
          end
        end

        CheckResult.new(result)
      end

      def to_s
        "EF(#{subformula})"
      end
    end
  end
end
