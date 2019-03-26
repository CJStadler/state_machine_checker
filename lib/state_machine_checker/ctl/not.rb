require_relative "formula"

module StateMachineChecker
  module CTL
    # The logical negation of a formula.
    class Not < Formula
      # @param [Formula] subformula
      def initialize(subformula)
        @subformula = subformula
      end

      # Return an enumerator over the atoms of the sub-formula
      #
      # @return [Enumerator<Atom>]
      def atoms
        subformula.atoms
      end

      # States of the model that satisfy all sub-formulae.
      #
      # @param [LabeledMachine] model
      # @return [Set<Symbol>]
      def satisfying_states(model)
        Set.new(model.states) - subformula.satisfying_states(model)
      end

      private

      attr_reader :subformula
    end
  end
end
