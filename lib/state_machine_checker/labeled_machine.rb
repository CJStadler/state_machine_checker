module StateMachineChecker
  # A finite state machine where every node is mapped to a set of labels. AKA a
  # Kripke structure.
  class LabeledMachine
    # @param [FiniteStateMachine] fsm
    # @param [Labeling] labeling
    def initialize(fsm, labeling)
      @fsm = fsm
      @labeling = labeling
    end

    # (see StateMachineChecker::FiniteStateMachine#initial_state)
    def initial_state
      fsm.initial_state
    end

    # (see StateMachineChecker::FiniteStateMachine#states)
    def states
      fsm.states
    end

    # (see StateMachineChecker::FiniteStateMachine#previous_states)
    def previous_states(state)
      fsm.previous_states(state)
    end

    # (see StateMachineChecker::FiniteStateMachine#predecessor_states)
    def predecessor_states(state)
      fsm.predecessor_states(state)
    end

    # (see StateMachineChecker::Labeling#for_state)
    def labels_for_state(state)
      labeling.for_state(state)
    end

    private

    attr_reader :fsm, :labeling
  end
end
