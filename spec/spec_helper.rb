require "bundler/setup"
require "state_machine_checker"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include StateMachineChecker
  config.include StateMachineChecker::CTL::API
end

# Helper for making transition.
def trans(from, to, name)
  StateMachineChecker::Transition.new(from, to, name)
end

# Helper for building a labeled machine.
def labeled_machine(initial, transitions, labels)
  fsm = StateMachineChecker::FiniteStateMachine.new(initial, transitions)

  labeling = instance_double(StateMachineChecker::Labeling)
  allow(labeling).to receive(:for_state) { |s| labels[s] }

  StateMachineChecker::LabeledMachine.new(fsm, labeling)
end
