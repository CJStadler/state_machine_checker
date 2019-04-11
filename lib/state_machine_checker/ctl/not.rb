require_relative "unary_operator"
require "state_machine_checker/check_result"
require "state_machine_checker/state_result"

module StateMachineChecker
  module CTL
    # The logical negation of a formula.
    class Not < UnaryOperator
      # Check whether each state is not satisfied by the subformula.
      #
      # @param [LabeledMachine] model
      # @return [CheckResult]
      def check(model)
        subresult = subformula.check(model)

        result = model.states.each_with_object({}) { |state, h|
          state_result = subresult.for_state(state)

          # Negate whether it was satisfied, keep the same path.
          path = if state_result.satisfied?
            state_result.witness
          else
            state_result.counterexample
          end
          h[state] = StateResult.new(!state_result.satisfied?, path)
        }

        CheckResult.new(result)
      end
    end
  end
end
