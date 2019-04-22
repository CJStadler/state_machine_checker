require_relative "binary_formula"
require_relative "not"

module StateMachineChecker
  module CTL
    # Logical implication.
    class Implication < BinaryFormula
      # @param [LabeledMachine] model
      # @return [CheckResult]
      def check(model)
        subformula1.and(subformula2).or(Not.new(subformula1)).check(model)
      end

      def to_s
        "(#{subformula1}) ⇒ (#{subformula2})"
      end
    end
  end
end
