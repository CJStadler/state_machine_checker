require "./lib/state_machine_checker/ctl/atom.rb"
require "./lib/state_machine_checker/labeled_machine.rb"

RSpec.describe StateMachineChecker::CTL::Atom do
  describe "#apply" do
    it "evaluates the atom for the given object" do
      a1 = described_class.new(:foo?)
      a2 = described_class.new ->(x) { x.foo? }

      [a1, a2].each do |atom|
        obj1 = double("obj1", foo?: true)
        obj2 = double("obj2", foo?: false)

        expect(atom.apply(obj1)).to eq(true)
        expect(obj1).to have_received(:foo?)

        expect(atom.apply(obj2)).to eq(false)
        expect(obj2).to have_received(:foo?)
      end
    end
  end

  describe "#atoms" do
    it "contains only the atom itself" do
      atom = described_class.new(:foo?)
      expect(atom.atoms).to contain_exactly(atom)
    end
  end

  describe "#satisfying_states" do
    it "enumerates the states which have this atom as a label" do
      atom = described_class.new(:foo?)

      machine = instance_double(StateMachineChecker::LabeledMachine)
      allow(machine).to receive(:states)
        .and_return([:a, :b])
      allow(machine).to receive(:labels_for_state)
        .with(:a)
        .and_return([atom])
      allow(machine).to receive(:labels_for_state)
        .with(:b)
        .and_return([described_class.new(:bar?)])

      expect(atom.satisfying_states(machine)).to contain_exactly(:a)
    end
  end
end
