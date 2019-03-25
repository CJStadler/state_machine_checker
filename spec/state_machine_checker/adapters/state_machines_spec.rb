require "./lib/state_machine_checker/adapters/state_machines.rb"
require "./spec/machines/simple_machine.rb"
require "./spec/machines/cyclic_machine.rb"

RSpec.describe StateMachineChecker::Adapters::StateMachines do
  describe "#finite_state_machine" do
    it "extracts the correct initial state and transitions" do
      [SimpleMachine, CyclicMachine].each do |machine_class|
        gem_machine = machine_class.state_machine
        adapter = described_class.new(gem_machine)

        expected_fsm = machine_class.finite_state_machine
        expect(adapter.initial_state).to eq(expected_fsm.initial_state)
        expect(adapter.transitions).to match_array(expected_fsm.transitions)
      end
    end
  end
end
