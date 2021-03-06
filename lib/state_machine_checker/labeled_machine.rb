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

    # (see StateMachineChecker::FiniteStateMachine#transitions)
    def transitions
      fsm.transitions
    end

    # (see StateMachineChecker::FiniteStateMachine#states)
    def states
      fsm.states
    end

    # (see StateMachineChecker::FiniteStateMachine#traverse)
    def traverse(from_state, reverse: false, &block)
      fsm.traverse(from_state, reverse: reverse, &block)
    end

    # (see StateMachineChecker::FiniteStateMachine#transitions_to)
    def transitions_to(state)
      fsm.transitions_to(state)
    end

    # (see StateMachineChecker::FiniteStateMachine#transitions_from)
    def transitions_from(state)
      fsm.transitions_from(state)
    end

    # (see StateMachineChecker::Labeling#for_state)
    def labels_for_state(state)
      labeling.for_state(state)
    end

    private

    attr_reader :fsm, :labeling
  end
end
