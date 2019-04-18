require "state_machine_checker"

module StateMachineChecker
  module RspecMatchers
    def satisfy(formula)
      SatisfyMatcher.new(formula)
    end

    class SatisfyMatcher
      include StateMachineChecker

      def initialize(formula)
        @formula = formula
      end

      def description
        "satisfy \"#{formula}\""
      end

      def diffable?
        false
      end

      def matches?(instance_generator)
        @instance_generator = instance_generator
        @result = check_satisfied(formula, instance_generator)
        @result.satisfied?
      end

      def failure_message
        <<~MESSAGE
          Expected machine to satisfy "#{formula}" but it does not.
          Counterexample: #{result.counterexample}
        MESSAGE
      end

      def failure_message_when_negated
        <<~MESSAGE
          Expected machine not to satisfy #{formula} but it does.
          Witness: #{result.witness}
        MESSAGE
      end

      def supports_block_expectations?
        true
      end

      private

      attr_reader :instance_generator, :formula, :result
    end
  end
end
