require_relative "unary_operator"
require_relative "e_x"
require_relative "not"

module StateMachineChecker
  module CTL
    # The universal next operator.
    class AX < UnaryOperator
      # @param [LabeledMachine] model
      # @return [CheckResult]
      def check(model)
        Not.new(CTL::EX.new(Not.new(subformula))).check(model)
      end

      def to_s
        "AX(#{subformula})"
      end
    end
  end
end
