require "./lib/state_machine_checker/labeling.rb"
require "./lib/state_machine_checker/ctl/atom.rb"
require "./lib/state_machine_checker/transition.rb"
require "./lib/state_machine_checker/finite_state_machine.rb"
require "./spec/machines/simple_machine.rb"
require "./spec/machines/cyclic_machine.rb"

RSpec.describe StateMachineChecker::Labeling do
  describe "#for_state" do
    context "for a simple machine" do
      it "returns atoms that are true in the state" do
        machine = SimpleMachine.finite_state_machine

        one = StateMachineChecker::CTL::Atom.new(:one?)
        two = StateMachineChecker::CTL::Atom.new(:two?)
        always = StateMachineChecker::CTL::Atom.new(->(x) { true })
        atoms = [one, two, always]

        labeling = described_class.new(atoms, machine, -> { SimpleMachine.new })

        expect(labeling.for_state(:one)).to contain_exactly(one, always)
        expect(labeling.for_state(:two)).to contain_exactly(two, always)
      end
    end

    context "for a complex machine with cycles" do
      it "returns atoms that are true in the state" do
        machine = CyclicMachine.finite_state_machine

        state_atoms = machine.states.each_with_object({}) { |state, h|
          h[state] = StateMachineChecker::CTL::Atom.new("#{state}?".to_sym)
        }
        always = StateMachineChecker::CTL::Atom.new(->(x) { true })
        atoms = state_atoms.values.push(always)

        labeling = described_class.new(atoms, machine, -> { CyclicMachine.new })

        machine.states.each do |state|
          expect(labeling.for_state(state))
            .to contain_exactly(state_atoms[state], always)
        end
      end
    end
  end
end
