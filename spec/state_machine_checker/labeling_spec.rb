require "./lib/state_machine_checker/labeling.rb"
require "./lib/state_machine_checker/ctl/atom.rb"
require "./lib/state_machine_checker/transition.rb"
require "./lib/state_machine_checker/finite_state_machine.rb"
require "./spec/machines/simple_machine.rb"

RSpec.describe StateMachineChecker::Labeling do
  describe "#for_state" do
    context "for a simple machine" do
      it "returns atoms that are true in the state" do
        one = StateMachineChecker::CTL::Atom.new(:one?)
        two = StateMachineChecker::CTL::Atom.new(:two?)
        always = StateMachineChecker::CTL::Atom.new(->(x) { true })
        atoms = [one, two, always]

        machine = StateMachineChecker::FiniteStateMachine.new(
          :one,
          [StateMachineChecker::Transition.new(:one, :two, :go)]
        )

        labeling = described_class.new(atoms, machine, -> { SimpleMachine.new })

        expect(labeling.for_state(:one)).to contain_exactly(one, always)
        expect(labeling.for_state(:two)).to contain_exactly(two, always)
      end
    end
  end
end
