require_relative "binary_formula"

module StateMachineChecker
  module CTL
    # The existential until operator. This is the "strong" until, it is only
    # satisfied if the second sub-formula is eventually satisifed.
    class EU < BinaryFormula
      # Check which states of the model have a path for which the first
      # subformula is satisifed until the second subformula is.
      #
      # @param [LabeledMachine] model
      # @return [CheckResult]
      def check(model)
        subresult1 = subformula1.check(model)
        subresult2 = subformula2.check(model)

        result = subresult2.to_h # States satisfying sub-formula2 satisfy this.

        model.states.lazy.select { |s| subresult2.for_state(s).satisfied? }.each do |end_state|
          model.traverse(end_state, reverse: true) do |state, path|
            if state == end_state || subresult1.for_state(state).satisfied?
              # Don't update states that are already satisfied, to keep the
              # simpler witness.
              unless result[state].satisfied?
                result[state] = StateResult.new(true, path)
              end
              true
            else
              false
            end
          end
        end

        CheckResult.new(result)
      end

      def to_s
        "(#{subformula1}) EU (#{subformula2})"
      end
    end
  end
end
