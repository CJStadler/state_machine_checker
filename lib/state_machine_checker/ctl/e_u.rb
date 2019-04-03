require_relative "formula"

module StateMachineChecker
  module CTL
    # The existential until operator.
    class EU < Formula
      # @param [Formula] subformula1 holds until subformula2.
      # @param [Formula] subformula2
      def initialize(subformula1, subformula2)
        @subformula1 = subformula1
        @subformula2 = subformula2
      end

      # Return an enumerator over the atoms of the sub-formulas.
      #
      # @return [Enumerator<Atom>]
      def atoms
        subformula1.atoms.chain(subformula2.atoms).lazy.flat_map(&:atoms)
      end

      # The states from which a state which satisfies the sub-formula is
      # reachable.
      #
      # @param [LabeledMachine] model
      # @return [Set<Symbol>]
      def satisfying_states(model)
        substates1 = subformula1.satisfying_states(model)
        substates2 = subformula2.satisfying_states(model)

        substates2.each_with_object(Set.new) { |state, set|
          predecessors = model.predecessor_states(state) { |s| substates1.include? s }
          set.merge(predecessors)
        }.merge(substates2)
      end

      private

      attr_reader :subformula1, :subformula2
    end
  end
end
