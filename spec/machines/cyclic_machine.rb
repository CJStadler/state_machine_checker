require "state_machines"
require "./lib/state_machine_checker/finite_state_machine.rb"
require "./lib/state_machine_checker/transition.rb"

# A complex machine with cycles.
class CyclicMachine
  # Our internal representation of the state machine.
  def self.finite_state_machine
    StateMachineChecker::FiniteStateMachine.new(
      :a,
      [
        StateMachineChecker::Transition.new(:a, :b, :ab),
        StateMachineChecker::Transition.new(:b, :c, :bc),
        StateMachineChecker::Transition.new(:c, :b, :cb),
        StateMachineChecker::Transition.new(:c, :d, :cd),
        StateMachineChecker::Transition.new(:b, :d, :bd),
        StateMachineChecker::Transition.new(:a, :e, :ae),
      ],
    )
  end

  state_machine initial: :a do
    event :ab do
      transition a: :b
    end

    event :bc do
      transition b: :c
    end

    event :cb do
      transition c: :b
    end

    event :cd do
      transition c: :d
    end

    event :bd do
      transition b: :d
    end

    event :ae do
      transition a: :e
    end
  end
end
