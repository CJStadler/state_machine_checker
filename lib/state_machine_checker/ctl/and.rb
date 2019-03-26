require_relative "formula"

module StateMachineChecker
  module CTL
    # The logical conjunction of two or more sub-formulae.
    class And < Formula
      # Conjoin several formulae.
      #
      # @param [Enumerator<Formula>] subformulae
      #
      # @example
      #   And.new([Atom.new(:even?), Atom.new(:positive?)])
      def initialize(subformulae)
        @subformulae = subformulae
      end

      # Return an enumerator over the atoms of all sub-formulae.
      #
      # @return [Enumerator<Atom>]
      def atoms
        subformulae.lazy.flat_map(&:atoms)
      end

      # States of the model that satisfy all sub-formulae.
      #
      # @param [LabeledMachine] model
      # @return [Set<Symbol>]
      def satisfying_states(model)
        subformulae
          .lazy
          .map { |f| Set.new(f.satisfying_states(model)) }
          .reduce(:intersection)
      end

      private

      attr_reader :subformulae
    end
  end
end
