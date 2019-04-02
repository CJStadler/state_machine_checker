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

  describe "#satisfying_states" do
    it "returns states which have a path for which the subformula is always true" do
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

      labeling = instance_double(StateMachineChecker::Labeling)
      allow(labeling).to receive(:for_state) { |s| labels[s] }

      transitions = [
        [:a, :b],
        [:b, :c],
        [:c, :b],
        [:a, :d],
        [:d, :e],
        [:e, :f],
      ].map { |from, to| StateMachineChecker::Transition.new(from, to, "#{from}_#{to}") }

      fsm = StateMachineChecker::FiniteStateMachine.new(:a, transitions)
      machine = StateMachineChecker::LabeledMachine.new(fsm, labeling)

      expect(eg.satisfying_states(machine)).to contain_exactly(:a, :b, :c, :f)
    end
  end
end
