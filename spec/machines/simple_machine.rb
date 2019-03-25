require "state_machines"
require "./lib/state_machine_checker/finite_state_machine.rb"
require "./lib/state_machine_checker/transition.rb"

class SimpleMachine
  # Our internal representation of the state machine.
  def self.finite_state_machine
    StateMachineChecker::FiniteStateMachine.new(
      :one,
      [StateMachineChecker::Transition.new(:one, :two, :go)]
    )
  end

  state_machine initial: :one do
    event :go do
      transition one: :two
    end
  end
end
