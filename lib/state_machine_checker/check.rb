module StateMachineChecker
  # A check whether a given model satisfies a given formula.
  class Check
    # @param [CTL::Formula] formula
    # @param [LabeledMachine] labeled_machine
    # @param [Proc] instance_generator a function which returns an instance of
    # the class being checked.
    def initialize(formula, labeled_machine, instance_generator)
      @formula = formula
      @labeled_machine = labeled_machine
      @instance_generator = instance_generator
    end

    # Whether the formula is satisfied by the labeled_machine.
    #
    # @return [Boolean]
    def satisfied?
      formula.satisfying_states(labeled_machine)
        .include?(labeled_machine.initial_state)
    end

    def counterexample
      # TODO
    end

    private

    attr_reader :formula, :instance_generator, :labeled_machine
  end
end
