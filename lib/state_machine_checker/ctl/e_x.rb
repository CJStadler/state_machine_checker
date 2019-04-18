require_relative "unary_operator"
require "state_machine_checker/check_result"
require "state_machine_checker/state_result"

module StateMachineChecker
  module CTL
    # The existential next operator.
    class EX < UnaryOperator
      # Check which states of the model have as a direct successor a state
      # satisfying the subformula.
      #
      # @param [LabeledMachine] model
      # @return [CheckResult]
      def check(model)
        # Initialize hash with every state unsatisfied.
        result = model.states.each_with_object({}) { |s, h|
          h[s] = StateResult.new(false, [])
        }

        subresult = subformula.check(model)
        model.states.each do |state|
          sub_state_result = subresult.for_state(state)

          if sub_state_result.satisfied? # Mark direct predecessors as satisfied.
            model.transitions_to(state).each do |transition|
              witness = [transition.name] + sub_state_result.witness
              result[transition.from] = StateResult.new(true, witness)
            end
          end
        end

        CheckResult.new(result)
      end

      def to_s
        "EX #{subformula}"
      end
    end
  end
end
