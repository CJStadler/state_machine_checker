require "state_machine_checker/version"
require "state_machine_checker/finite_state_machine"
require "state_machine_checker/labeled_machine"
require "state_machine_checker/labeling"
require "state_machine_checker/adapters/state_machines"
require "state_machine_checker/ctl/api"

# The main entrypoint is {#check_satisfied}. The other methods are provided
# primarily for debugging and transparency.
module StateMachineChecker
  # Check whether a formula is satisfied by the state machine of a given class.
  #
  # @param [CTL::Formula] formula the formula that should be satisfied.
  # @param instance_generator a thunk (zero-argument function) that must return
  #   an instance of an object containing a state machine. The instance must be
  #   in the initial state.
  # @return [StateResult] the result for the initial state.
  def check_satisfied(formula, instance_generator)
    labeled_machine = build_labeled_machine(formula, instance_generator)
    check = formula.check(labeled_machine)
    check.for_state(labeled_machine.initial_state)
  end

  # Build a labeled machine (Kripke structure) over the atomic propositions
  # contained in the given formula.
  #
  # @param [CTL::Formula] formula the formula from which to extract atomic
  #   propositions.
  # @param instance_generator a thunk (zero-argument function) that must return
  #   an instance of an object containing a state machine. The instance must be
  #   in the initial state.
  # @return [LabeledMachine]
  def build_labeled_machine(formula, instance_generator)
    # TODO: Assumes state_machines gem.
    gem_machine = instance_generator.call.class.state_machine
    adapter = Adapters::StateMachines.new(gem_machine)
    fsm = FiniteStateMachine.new(adapter.initial_state, adapter.transitions)
    LabeledMachine.new(
      fsm,
      Labeling.new(formula.atoms, fsm, instance_generator)
    )
  end
end
