require_relative "formula"

module StateMachineChecker
  module CTL
    # The logical disjunction of two or more sub-formulae.
    class Or < Formula
      # Disjoin several formulae.
      #
      # @example
      #   Or.new([Atom.new(:even?), Atom.new(:positive?)])
      def initialize(subformulae)
        @subformulae = subformulae
      end

      # Return an enumerator over the atoms of all sub-formulae.
      #
      # @return [Enumerator]
      def atoms
        subformulae.lazy.flat_map(&:atoms)
      end

      # Check which states of the model are satisfied by at least one subformulae.
      #
      # @param [LabeledMachine] model
      # @return [CheckResult]
      def check(model)
        sub_results = subformulae.map { |f| f.check(model) }

        result = {}
        model.states.each do |state|
          state_results = sub_results.lazy.map { |r| r.for_state(state) }
          satisfying = state_results.find(&:satisfied?)

          result[state] = satisfying || state_results.first
        end

        CheckResult.new(result)
      end

      private

      attr_reader :subformulae
    end
  end
end
