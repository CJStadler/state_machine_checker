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

  describe "#check" do
    it "marks states as satisfying which have a direct successor satisfying the subformula" do
      atom = StateMachineChecker::CTL::Atom.new(:foo?)
      ex = described_class.new(atom)

      labels = {
        a: Set[atom],
        b: Set[atom],
        c: Set[],
        d: Set[],
        e: Set[],
      }

      transitions = [
        trans(:a, :b, :ab),
        trans(:a, :c, :ac),
        trans(:c, :b, :cb),
        trans(:d, :b, :db),
        trans(:b, :d, :bd),
        trans(:d, :e, :de),
      ]

      machine = labeled_machine(:a, transitions, labels)

      result = ex.check(machine)
      expect(result.for_state(:a)).to have_attributes(satisfied?: true, witness: [:ab])
      expect(result.for_state(:b)).to have_attributes(satisfied?: false, counterexample: [])
      expect(result.for_state(:c)).to have_attributes(satisfied?: true, witness: [:cb])
      expect(result.for_state(:d)).to have_attributes(satisfied?: true, witness: [:db])
      expect(result.for_state(:e)).to have_attributes(satisfied?: false, counterexample: [])
    end
  end

  describe "#to_s" do
    it "returns the formula as a string" do
      atom = StateMachineChecker::CTL::Atom.new(:foo?)
      f = described_class.new(atom)
      expect(f.to_s).to eq("EX(foo?)")
    end
  end
end
