require_relative "binary_formula"
require_relative "e_g"
require_relative "e_u"
require_relative "not"

module StateMachineChecker
  module CTL
    # The universal until operator.
    class AU < BinaryFormula
      # @param [LabeledMachine] model
      # @return [CheckResult]
      def check(model)
        Not.new(Not.new(subformula2).EU(Not.new(subformula1.or(subformula2)))
          .or(EG.new(Not.new(subformula2))))
          .check(model)
      end

      def to_s
        "(#{subformula1}) AU (#{subformula2})"
      end
    end
  end
end
