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
        b: Set[],
        c: Set[atom],
        d: Set[],
        e: Set[],
        f: Set[],
        g: Set[atom],
      }

      transitions = [
        trans(:a, :g, :ag),
        trans(:a, :b, :ab),
        trans(:b, :b, :bb),
        trans(:b, :c, :bc),
        trans(:c, :d, :cd),
        trans(:a, :e, :ae),
        trans(:e, :f, :ef),
      ]

      machine = labeled_machine(:a, transitions, labels)

      result = ef.check(machine)
      expect(result.for_state(:a)).to have_attributes(satisfied?: true, witness: [:ab, :bc])
      expect(result.for_state(:b)).to have_attributes(satisfied?: true, witness: [:bc])
      expect(result.for_state(:c)).to have_attributes(satisfied?: true, witness: [])
      expect(result.for_state(:d)).to have_attributes(satisfied?: false, counterexample: [])
      expect(result.for_state(:e)).to have_attributes(satisfied?: false, counterexample: [])
      expect(result.for_state(:f)).to have_attributes(satisfied?: false, counterexample: [])
      expect(result.for_state(:g)).to have_attributes(satisfied?: true, witness: [])
    end
  end
end
