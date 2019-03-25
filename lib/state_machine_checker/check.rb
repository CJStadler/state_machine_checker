module StateMachineChecker
  # A check whether a given model satisfies a given formula.
  class Check
    # @param [CTL::Formula] formula
    # @param [FiniteStateMachine] machine
    # @param [Proc] instance_generator a function which returns an instance of
    # the class being checked.
    def initialize(formula, machine, instance_generator)
      @formula = formula
      @machine = machine
      @instance_generator = instance_generator
    end

    # @return [LabeledMachine]
    def labeled_machine
      @labeled_machine ||= LabeledMachine.new(
        machine,
        Labeling.new(formula.atoms, machine, instance_generator)
      )
    end

    # Whether the formula is satisfied by the labeled_machine.
    def satisfied?
      formula.satisfying_states.include?(machine.initial)
    end

    def counterexample
      # TODO
    end

    private

    attr_reader :formula, :instance_generator, :machine
  end
end
