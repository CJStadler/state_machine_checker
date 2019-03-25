require "state_machine_checker/ctl/atom"
require "state_machine_checker/ctl/and"
require "state_machine_checker/labeled_machine"

RSpec.describe StateMachineChecker::CTL::And do
  describe "#atoms" do
    it "enumerates the atoms of its subformulae" do
      a1 = StateMachineChecker::CTL::Atom.new(:foo?)
      a2 = StateMachineChecker::CTL::Atom.new(:bar?)
      a3 = StateMachineChecker::CTL::Atom.new(:zzz?)

      and1 = described_class.new([a1, a2])
      and2 = described_class.new([a3, and1])

      expect(and1.atoms).to contain_exactly(a1, a2)
      expect(and2.atoms).to contain_exactly(a1, a2, a3)
    end
  end

  describe "#satisfying_states" do
    it "enumerates states which satisfy all subformulae" do
      a1 = StateMachineChecker::CTL::Atom.new(:foo?)
      a2 = StateMachineChecker::CTL::Atom.new(:bar?)

      labels = {
        a: [a1],
        b: [a1, a2],
        c: [],
        d: [a1, a2],
        e: [a2],
      }

      machine = instance_double(StateMachineChecker::LabeledMachine)
      allow(machine).to receive(:states).and_return(labels.keys)
      allow(machine).to receive(:labels_for_state) { |s| Set.new(labels[s]) }

      and1 = described_class.new([a1, a2])
      expect(and1.satisfying_states(machine)).to contain_exactly(:b, :d)
    end
  end
end
