require_relative "../transition"

module StateMachineChecker
  module Adapters
    # An adapter for the state_machines gem.
    class StateMachines
      # @param [StateMachines::Machine] gem_machine
      def initialize(gem_machine)
        @gem_machine = gem_machine
      end

      def initial_state
        # StateMachines::Machine#initial_state takes an instance as a parameter,
        # even when the initial state is set statically. We are assuming that
        # it is always set statically.
        # TODO: could get this by `gem_machine.states.find(&:initial)`
        gem_machine.instance_variable_get(:@initial_state)
      end

      def transitions
        gem_machine.events.flat_map { |event|
          event.branches.flat_map { |branch|
            branch.state_requirements.flat_map { |state_requirement|
              froms = state_requirement[:from].values
              tos = state_requirement[:to].values

              froms.product(tos).map { |from, to|
                Transition.new(from, to, event.name)
              }
            }
          }
        }
      end

      private

      attr_reader :gem_machine
    end
  end
end
