require "state_machine_checker/version"
require "state_machine_checker/ctl"
require "state_machine_checker/check"

module StateMachineChecker
  include CTL

  def check_satisfied(formula, model_generator)
    Check.new(formula, model_generator)
  end
end
