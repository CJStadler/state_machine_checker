require "state_machine_checker/ctl/atom"
require "state_machine_checker/ctl/e_f"
require "state_machine_checker/labeled_machine"

RSpec.describe StateMachineChecker::CTL::EF do
  describe "#atoms" do
    it "enumerates the atoms of its subformula" do
      a1 = StateMachineChecker::CTL::Atom.new(:foo?)
      a2 = StateMachineChecker::CTL::Atom.new(:bar?)

      and1 = StateMachineChecker::CTL::And.new([a1, a2])
      ef = described_class.new(and1)

      expect(ef.atoms).to contain_exactly(a1, a2)
    end
  end

  describe "#satisfying_states" do
    it "returns states which have a successor satisfying the subformula" do
      atom = StateMachineChecker::CTL::Atom.new(:foo?)
      ef = described_class.new(atom)

      labels = {
        a: Set[],
        b: Set[atom],
        c: Set[],
        d: Set[atom],
        e: Set[],
      }

      predecessor_states = {
        a: Set[],
        b: Set[:a, :b],
        c: Set[:a, :b],
        d: Set[:a],
        e: Set[:a, :d],
      }

      machine = instance_double(StateMachineChecker::LabeledMachine)
      allow(machine).to receive(:states).and_return(labels.keys)
      allow(machine).to receive(:predecessor_states) { |s| predecessor_states[s] }
      allow(machine).to receive(:labels_for_state) { |s| labels[s] }

      expect(ef.satisfying_states(machine)).to contain_exactly(:a, :b, :d)
    end
  end
end
