module StateMachineChecker
  # A mapping from states to the values of each atom.
  class Labeling
    # @param [Enumerator<Atom>] atoms the atoms which will be the labels.
    # @param [FiniteStateMachine] machine the machine to generate labels for.
    # @param [Proc] instance_generator a nullary function which returns an
    #   instance of an object in the initial state.
    def initialize(atoms, machine, instance_generator)
      @labels_by_state = build_map(atoms, machine, instance_generator)
    end

    # Get the labels for the given state.
    #
    # @param [Symbol] state
    # @return [Set<Atom>] the atoms which are true in the state
    def for_state(state)
      labels_by_state[state]
    end

    private

    attr_reader :labels_by_state

    # Generate a hash of state -> atoms
    def build_map(atoms, machine, instance_generator)
      machine.state_paths.each_with_object({}) { |(state, transitions), states_map|
        instance = instance_from_transitions(transitions, instance_generator)

        states_map[state] = atoms.each_with_object(Set.new) { |atom, labels|
          if atom.apply(instance)
            labels << atom
          end
        }
      }
    end

    # Walk an instance through the given transitions.
    def instance_from_transitions(transitions, instance_generator)
      instance = instance_generator.call

      transitions.each do |transition|
        transition.execute(instance)
      end

      instance
    end
  end
end
