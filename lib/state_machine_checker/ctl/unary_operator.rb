module StateMachineChecker
  module CTL
    # Abstract base class for operators with a single sub-formula.
    class UnaryOperator < Formula
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

      private

      attr_reader :subformula
    end
  end
end
