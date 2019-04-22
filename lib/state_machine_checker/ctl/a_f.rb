require_relative "unary_operator"
require_relative "e_g"
require_relative "not"

module StateMachineChecker
  module CTL
    # The universal eventually operator.
    class AF < UnaryOperator
      # @param [LabeledMachine] model
      # @return [CheckResult]
      def check(model)
        Not.new(CTL::EG.new(Not.new(subformula))).check(model)
      end

      def to_s
        "AF(#{subformula})"
      end
    end
  end
end
