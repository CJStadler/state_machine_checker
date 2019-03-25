require "state_machine_checker/version"
require "state_machine_checker/ctl"
require "state_machine_checker/check"

module StateMachineChecker
  def check_satisfied(formula, model_generator)
    # TODO: Assumes state_machines gem.
    machine = model_generator.call.class.state_machine
    Check.new(formula, machine, model_generator)
  end
end
