require "state_machine_checker/ctl/atom"
require "state_machine_checker/ctl/e_u"
require "state_machine_checker/labeled_machine"

RSpec.describe StateMachineChecker::CTL::EU do
  describe "#atoms" do
    it "enumerates the atoms of its subformulae" do
      a1 = StateMachineChecker::CTL::Atom.new(:foo?)
      a2 = StateMachineChecker::CTL::Atom.new(:bar?)

      and1 = StateMachineChecker::CTL::And.new([a1, a2])
      a3 = StateMachineChecker::CTL::Atom.new(:blah?)
      eu = described_class.new(and1, a3)

      expect(eu.atoms).to contain_exactly(a1, a2, a3)
    end
  end

  describe "#satisfying_states" do
    it "returns states from which there is a path where the first formula is true until the second is" do
      a1 = StateMachineChecker::CTL::Atom.new(:foo?)
      a2 = StateMachineChecker::CTL::Atom.new(:bar?)
      eu = described_class.new(a1, a2)

      labels = {
        a: Set[a1],
        b: Set[a1, a2],
        c: Set[],
        d: Set[a1],
        e: Set[a2],
      }

      predecessor_states = {
        a: Set[],
        b: Set[:a],
        c: Set[],
        d: Set[],
        e: Set[:d],
      }

      machine = instance_double(StateMachineChecker::LabeledMachine)
      allow(machine).to receive(:states).and_return(labels.keys)
      allow(machine).to receive(:predecessor_states) { |s| predecessor_states[s] }
      allow(machine).to receive(:labels_for_state) { |s| labels[s] }

      expect(eu.satisfying_states(machine)).to contain_exactly(:a, :b, :d, :e)
    end
  end
end
