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
        c: Set[a1],
        d: Set[],
        e: Set[a1],
        f: Set[a2],
        g: Set[a1],
      }

      transitions = [
        trans(:a, :a, :aa),
        trans(:a, :b, :ab),
        trans(:b, :c, :bc),
        trans(:c, :d, :cd),
        trans(:d, :e, :de),
        trans(:e, :f, :ef),
        trans(:f, :g, :fg),
        trans(:g, :g, :gg),
      ]

      machine = labeled_machine(:a, transitions, labels)

      result = eu.check(machine)
      expect(result.for_state(:a)).to have_attributes(satisfied?: true, witness: [:ab])
      expect(result.for_state(:b)).to have_attributes(satisfied?: true, witness: [])
      expect(result.for_state(:c)).to have_attributes(satisfied?: false, counterexample: [])
      expect(result.for_state(:d)).to have_attributes(satisfied?: false, counterexample: [])
      expect(result.for_state(:e)).to have_attributes(satisfied?: true, witness: [:ef])
      expect(result.for_state(:f)).to have_attributes(satisfied?: true, witness: [])
      expect(result.for_state(:g)).to have_attributes(satisfied?: false, counterexample: [])
    end
  end
end
