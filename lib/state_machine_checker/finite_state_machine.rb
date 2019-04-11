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

    # Traverse the graph from the given state. Yield each state and the
    # transitions from it to the from_state. If the result of the block is falsey
    # for any state then the search will not continue to the children of that
    # state.
    #
    # @param [Symbol] from_state
    # @param [true, false] reverse traverse in reverse?
    # @yield [Symbol, Array<Symbol>]
    def traverse(from_state, reverse: false, &block)
      rec_traverse(from_state, [], Set[from_state], reverse, &block)
    end

    def transitions_from(state)
      transitions.select { |t| t.from == state }
    end

    def transitions_to(state)
      transitions.select { |t| t.to == state }
    end

    private

    # Traverse the graph, maintaining a stack of transitions.
    def rec_traverse(state, stack, seen, reverse, &block)
      # If we are reverse searching than the stack will be in reverse order.
      path = reverse ? stack.reverse : stack.clone
      continue = block.yield(state, path.map(&:name)) != false

      if continue
        trans = if reverse
          transitions_to(state)
        else
          transitions_from(state)
        end

        trans.each do |transition|
          next_state = if reverse
            transition.from
          else
            transition.to
          end

          unless seen.include?(next_state)
            seen.add(next_state)
            stack.push(transition)

            rec_traverse(next_state, stack, seen, reverse, &block)

            stack.pop
          end
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
  end
end
