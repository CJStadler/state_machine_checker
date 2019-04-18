require_relative "formula"
require "state_machine_checker/check_result"
require "state_machine_checker/state_result"

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
        @name, @fn = if method_name_or_fn.respond_to?(:call)
          ["atom##{object_id}", method_name_or_fn]
        else
          # Create a function which will send the given method name.
          [method_name_or_fn.to_s, method_name_or_fn.to_proc]
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

      # Check which states of the machine are labeled with this atom.
      #
      # @param [LabeledMachine] machine
      # @return [CheckResult]
      def check(machine)
        result = machine.states.each_with_object({}) { |state, h|
          satisfied = machine.labels_for_state(state).include?(self)
          h[state] = StateResult.new(satisfied, [])
        }

        CheckResult.new(result)
      end

      def to_s
        name
      end

      private

      attr_reader :fn, :name
    end
  end
end
