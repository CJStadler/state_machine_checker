require "state_machine_checker/ctl/atom"
require "state_machine_checker/ctl/e_g"
require "state_machine_checker/finite_state_machine"
require "state_machine_checker/labeled_machine"
require "state_machine_checker/labeling"

RSpec.describe StateMachineChecker::CTL::EG do
  describe "#atoms" do
    it "enumerates the atoms of its subformula" do
      a1 = StateMachineChecker::CTL::Atom.new(:foo?)
      a2 = StateMachineChecker::CTL::Atom.new(:bar?)

      and1 = StateMachineChecker::CTL::And.new([a1, a2])
      eg = described_class.new(and1)

      expect(eg.atoms).to contain_exactly(a1, a2)
    end
  end

  describe "check" do
    it "marks states as satisfying from which there is a path where the subformula is always satisfied" do
      atom = StateMachineChecker::CTL::Atom.new(:foo?)
      eg = described_class.new(atom)

      labels = {
        a: Set[atom],
        b: Set[atom],
        c: Set[atom],
        d: Set[atom],
        e: Set[],
        f: Set[atom],
      }

      transitions = [
        trans(:a, :b, :ab),
        trans(:b, :c, :bc),
        trans(:c, :b, :cb),
        trans(:a, :d, :ad),
        trans(:d, :e, :de),
        trans(:e, :f, :ef),
      ]

      machine = labeled_machine(:a, transitions, labels)

      result = eg.check(machine)
      expect(result.for_state(:a)).to have_attributes(satisfied?: true, witness: [:ab, :bc, :cb])
      expect(result.for_state(:b)).to have_attributes(satisfied?: true, witness: [:bc, :cb])
      expect(result.for_state(:c)).to have_attributes(satisfied?: true, witness: [:cb, :bc])
      expect(result.for_state(:d)).to have_attributes(satisfied?: false, counterexample: [])
      expect(result.for_state(:e)).to have_attributes(satisfied?: false, counterexample: [])
      expect(result.for_state(:f)).to have_attributes(satisfied?: false, counterexample: [])
    end
  end

  describe "#to_s" do
    it "returns the formula as a string" do
      atom = StateMachineChecker::CTL::Atom.new(:foo?)
      f = described_class.new(atom)
      expect(f.to_s).to eq("EG foo?")
    end
  end
end
