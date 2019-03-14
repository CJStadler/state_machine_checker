require_relative "formula.rb"

module StateMachineChecker
  module CTL
    # An atomic proposition.
    class Atom < Formula
      # Create an atom.
      #
      # @example
      #   Atom.new(:shipped?)
      #   Atom.new(->(x) { x.shipped? })
      def initialize(method_name_or_fn)
        @fn = if method_name_or_fn.respond_to?(:call)
          fn
        else
          ->(x) { x.public_send(method_name_or_fn) }
        end
      end

      # Evaluate the atom on the given instance.
      #
      # @example
      #   even_atom = Atom.new(:even?)
      #   even_atom.apply(6) #=> true
      #   even_atom.appyy(7) #=> false
      def apply(instance)
        fn.call(instance)
      end

      # Returns an enumerator containing only self, as it is an atom.
      #
      # @return [Enumerator]
      def atoms
        [self]
      end

      # States of the model that satisfy this atom.
      #
      # @return [Enumerator]
      def satisfying_states(model)
        model.states.select { |state| state.atom_values[self] }
      end

      private

      attr_reader :fn
    end
  end
end
