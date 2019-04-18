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

      # Check which states of the model are satisfied by all subformulae.
      #
      # @param [LabeledMachine] model
      # @return [CheckResult]
      def check(model)
        sub_results = subformulae.lazy.map { |f| f.check(model) }
        sub_results.reduce(&:intersection)
      end

      def to_s
        subformulae.map(&:to_s).join(" ∧ ")
      end

      private

      attr_reader :subformulae
    end
  end
end
