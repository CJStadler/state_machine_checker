require "state_machine_checker/ctl/atom"
require "state_machine_checker/ctl/e_x"
require "state_machine_checker/labeled_machine"

RSpec.describe StateMachineChecker::CTL::EX do
  describe "#atoms" do
    it "enumerates the atoms of its subformula" do
      a1 = StateMachineChecker::CTL::Atom.new(:foo?)
      a2 = StateMachineChecker::CTL::Atom.new(:bar?)

      and1 = StateMachineChecker::CTL::And.new([a1, a2])
      ex = described_class.new(and1)

      expect(ex.atoms).to contain_exactly(a1, a2)
    end
  end

  describe "#satisfying_states" do
    it "enumerates states which have a successor satisfying the subformula" do
      atom = StateMachineChecker::CTL::Atom.new(:foo?)
      ex = described_class.new(atom)

      labels = {
        a: [atom],
        b: [atom],
        c: [],
        d: [],
        e: [],
      }

      previous_states = {
        a: [],
        b: [:c, :d],
        c: [:a],
        d: [:b],
        e: [:d],
      }

      machine = instance_double(StateMachineChecker::LabeledMachine)
      allow(machine).to receive(:states).and_return(labels.keys)
      allow(machine).to receive(:previous_states) { |s| previous_states[s] }
      allow(machine).to receive(:labels_for_state) { |s| Set.new(labels[s]) }

      expect(ex.satisfying_states(machine)).to contain_exactly(:c, :d)
    end
  end
end
