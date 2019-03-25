require_relative "formula.rb"

module StateMachineChecker
  module CTL
    # An atomic proposition about a single object.
    class Atom < Formula
      # @param [Symbol, Proc] method_name_or_fn
      #
      # @example
      #   Atom.new(:shipped?)
      #   Atom.new(->(x) { x.shipped? })
      def initialize(method_name_or_fn)
        @fn = if method_name_or_fn.respond_to?(:call)
          method_name_or_fn
        else
          # Create a function which will send the given method name.
          method_name_or_fn.to_proc
        end
      end

      # Evaluate the atom on the given instance.
      #
      # @example
      #   even_atom = Atom.new(:even?)
      #   even_atom.apply(6) #=> true
      #   even_atom.apply(7) #=> false
      def apply(instance)
        fn.call(instance)
      end

      # Returns an enumerator containing only this object, as it is an atom.
      #
      # @return [Enumerator<Atom>]
      def atoms
        [self]
      end

      # States of the machine that satisfy this atom.
      #
      # @param [LabeledMachine] machine
      # @return [Enumerator<Symbol>]
      def satisfying_states(machine)
        machine.states.select { |state|
          machine.labels_for_state(state).include?(self)
        }
      end

      private

      attr_reader :fn
    end
  end
end
