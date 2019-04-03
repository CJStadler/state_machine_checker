module StateMachineChecker
  # Represents a finite state machine: a set of states, an initial state, and
  # transitions among them.
  #
  # This class is used to limit the dependency on any particular state machine
  # library.
  class FiniteStateMachine
    attr_reader :initial_state, :transitions

    # @param [Symbol] initial_state the name of the initial state.
    # @param [Array<Transition>] transitions the transitions of the FSM.
    def initialize(initial_state, transitions)
      @initial_state = initial_state
      @transitions = transitions
    end

    # Enumerate the states and for each provide a path to it.
    #
    # @return [Enumerator<Array(Symbol, Array<Transition>)>] an enumerator where
    #   each element is a pair of a state and an array of transitions to reach the
    #   state.
    def state_paths
      Enumerator.new do |yielder|
        depth_first_search(Set.new, initial_state, [], yielder)
      end
    end

    # Enumerate the states.
    #
    # @return [Enumerator<Symbol>] an enumerator over the names of the states.
    def states
      seen = Set.new

      Enumerator.new do |yielder|
        seen << initial_state
        yielder << initial_state

        transitions.each do |transition|
          unless seen.include?(transition.from)
            seen << transition.from
            yielder << transition.from
          end

          unless seen.include?(transition.to)
            seen << transition.to
            yielder << transition.to
          end
        end
      end
    end

    # The states which have a transition leading directly to the given state.
    #
    # @param [Symbol] state the name of the state to search from.
    # @return [Set<Symbol>]
    def previous_states(state)
      transitions.select { |t| t.to == state }.map(&:from).to_set
    end

    # The states from which the given state is reachable.
    #
    # @param [Symbol] state the name of the state to search from.
    # @param [Block] &predicate optionally, only search as long as this is true.
    #   The block is given a single argument, the state.
    # @return [Set<Symbol>]
    def predecessor_states(state, &predicate)
      accumulator = Set.new

      reverse_dfs(accumulator, state, &predicate)

      accumulator
    end

    private

    # Add all states reachable from state to the accumulator.
    def reverse_dfs(accumulator, state, &predicate)
      prevs = previous_states(state)
      new = prevs - accumulator

      new.each do |s|
        if !predicate || yield(s)
          accumulator << s
          reverse_dfs(accumulator, s, &predicate)
        end
      end
    end

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
