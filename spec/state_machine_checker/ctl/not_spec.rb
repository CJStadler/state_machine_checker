require "state_machine_checker/ctl/atom"
require "state_machine_checker/ctl/and"
require "state_machine_checker/ctl/not"
require "state_machine_checker/labeled_machine"

RSpec.describe StateMachineChecker::CTL::Not do
  describe "#atoms" do
    it "enumerates the atoms of its subformula" do
      a1 = StateMachineChecker::CTL::Atom.new(:foo?)
      a2 = StateMachineChecker::CTL::Atom.new(:bar?)

      and1 = StateMachineChecker::CTL::And.new([a1, a2])
      not1 = described_class.new(and1)

      expect(not1.atoms).to contain_exactly(a1, a2)
    end
  end

  describe "#satisfying_states" do
    it "enumerates states which do not satisfy the subformula" do
      a1 = StateMachineChecker::CTL::Atom.new(:foo?)
      a2 = StateMachineChecker::CTL::Atom.new(:bar?)

      labels = {
        a: [a1],
        b: [a2],
        c: [],
      }

      machine = instance_double(StateMachineChecker::LabeledMachine)
      allow(machine).to receive(:states).and_return(labels.keys)
      allow(machine).to receive(:labels_for_state) { |s| labels[s].to_set }

      not1 = described_class.new(a1)
      expect(not1.satisfying_states(machine)).to contain_exactly(:b, :c)
    end
  end
end
