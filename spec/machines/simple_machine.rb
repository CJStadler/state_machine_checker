require "state_machines"

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
