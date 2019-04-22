require_relative "unary_operator"
require_relative "e_f"
require_relative "not"

module StateMachineChecker
  module CTL
    # The universal always operator.
    class AG < UnaryOperator
      # @param [LabeledMachine] model
      # @return [CheckResult]
      def check(model)
        Not.new(CTL::EF.new(Not.new(subformula))).check(model)
      end

      def to_s
        "AG(#{subformula})"
      end
    end
  end
end
