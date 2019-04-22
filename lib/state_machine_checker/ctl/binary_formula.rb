require_relative "formula"

module StateMachineChecker
  module CTL
    class BinaryFormula < Formula
      def initialize(subformula1, subformula2)
        @subformula1 = subformula1
        @subformula2 = subformula2
      end

      # Return an enumerator over the atoms of the sub-formulae.
      #
      # @return [Enumerator<Atom>]
      def atoms
        subformula1.atoms + subformula2.atoms
      end

      private

      attr_reader :subformula1, :subformula2
    end
  end
end
