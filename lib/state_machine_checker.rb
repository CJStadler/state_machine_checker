require "state_machine_checker/version"
require "state_machine_checker/check"
require "state_machine_checker/finite_state_machine"
require "state_machine_checker/labeled_machine"
require "state_machine_checker/labeling"
require "state_machine_checker/adapters/state_machines"
require "state_machine_checker/ctl/api"

module StateMachineChecker
  def check_satisfied(formula, model_generator)
    # TODO: Assumes state_machines gem.
    gem_machine = model_generator.call.class.state_machine
    adapter = Adapters::StateMachines.new(gem_machine)
    fsm = FiniteStateMachine.new(adapter.initial_state, adapter.transitions)
    labeled_machine = LabeledMachine.new(
      fsm,
      Labeling.new(formula.atoms, fsm, model_generator)
    )
    Check.new(formula, labeled_machine, model_generator)
  end
end
