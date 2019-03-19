module StateMachineChecker
  # Represents a finite state machine: a set of states, an initial state, and
  # transitions among them.
  #
  # This class is used to limit the dependency on any particular state machine
  # library.
  class FiniteStateMachine
    # @param [Symbol] initial the name of the initial state.
    # @param [Array<Transition>] transitions the transitions of the FSM.
    def initialize(initial, transitions)
      @initial = initial
      @transitions = transitions
    end

    # Enumerate the states and for each provide a path to it.
    #
    # @return [Enumerator] an enumerator where each element is a pair of a state
    #   and an array of transitions to reach the state.
    def state_paths
      Enumerator.new do |yielder|
        depth_first_search(Set.new, initial, [], yielder)
      end
    end

    private

    attr_reader :initial, :transitions

    def depth_first_search(visited, state, transitions, yielder)
      yielder << [state, transitions]

      visited.add(state)

      transitions_from(state).each do |transition|
        unless visited.include?(transition.to)
          new_transitions = transitions.clone
          new_transitions << transition
          depth_first_search(visited, transition.to, new_transitions, yielder)
        end
      end
    end

    def transitions_from(state)
      transitions.select { |t| t.from == state }
    end
  end
end
