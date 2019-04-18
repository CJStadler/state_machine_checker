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

  describe "#check" do
    it "marks states as satisfying which have this atom as a label" do
      atom = described_class.new(:foo?)

      transitions = [trans(:a, :b, :x), trans(:a, :c, :y)]
      labels = {
        a: Set[atom],
        b: Set[],
        c: Set[],
      }
      machine = labeled_machine(:a, transitions, labels)

      result = atom.check(machine)
      expect(result.for_state(:a)).to be_satisfied
      expect(result.for_state(:b)).not_to be_satisfied
      expect(result.for_state(:c)).not_to be_satisfied
    end
  end

  describe "#to_s" do
    context "when constructed from a symbol" do
      it "returns the symbol as a string" do
        a = described_class.new(:foo?)
        expect(a.to_s).to eq("foo?")
      end
    end

    context "when constructed from an anonymous function" do
      it "returns a unique identifier" do
        a = described_class.new(->(x) { x.even? })
        expect(a.to_s).to match(/\Aatom#\d+\z/)
      end
    end
  end
end
