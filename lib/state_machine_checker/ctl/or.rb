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

      # States of the model that satisfy at least one sub-formulae.
      #
      # @return [Enumerator]
      def satisfying_states(model)
        subformulae
          .lazy
          .map { |f| f.satisfying_states(model) }
          .reduce(:union)
      end

      private

      attr_reader :subformulae
    end
  end
end
