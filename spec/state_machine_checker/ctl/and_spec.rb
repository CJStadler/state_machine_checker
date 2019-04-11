require "state_machine_checker/ctl/atom"
require "state_machine_checker/ctl/and"
require "state_machine_checker/ctl/e_x"
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

  describe "#check" do
    it "marks states as satisfied which satisfy both subformulae" do
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
      allow(machine).to receive(:labels_for_state) { |s| labels[s].to_set }

      result = described_class.new([a1, a2]).check(machine)
      expect(result.for_state(:a)).to have_attributes(satisfied?: false, counterexample: [])
      expect(result.for_state(:b)).to have_attributes(satisfied?: true, witness: [])
      expect(result.for_state(:c)).to have_attributes(satisfied?: false, counterexample: [])
      expect(result.for_state(:d)).to have_attributes(satisfied?: true, witness: [])
      expect(result.for_state(:e)).to have_attributes(satisfied?: false, counterexample: [])
    end

    context "when one of the subformuale is not satisfied" do
      it "uses its counterexample" do
        path = instance_double(Array)
        f1_result = StateMachineChecker::CheckResult
          .new(a: StateMachineChecker::StateResult.new(false, path))
        f1 = instance_double(StateMachineChecker::CTL::EX)
        allow(f1).to receive(:check).and_return(f1_result)

        f2_result = StateMachineChecker::CheckResult
          .new(a: StateMachineChecker::StateResult.new(true, []))
        f2 = instance_double(StateMachineChecker::CTL::EX)
        allow(f2).to receive(:check).and_return(f2_result)

        model = instance_double(StateMachineChecker::LabeledMachine, states: Set[:a])

        result = described_class.new([f1, f2]).check(model)
        expect(result.for_state(:a)).to have_attributes(satisfied?: false, counterexample: path)
      end
    end

    context "when all subformulae are satisfied" do
      it "uses the witness of the first" do
        path = instance_double(Array)
        f1_result = StateMachineChecker::CheckResult
          .new(a: StateMachineChecker::StateResult.new(true, path))
        f1 = instance_double(StateMachineChecker::CTL::EX)
        allow(f1).to receive(:check).and_return(f1_result)

        f2_result = StateMachineChecker::CheckResult
          .new(a: StateMachineChecker::StateResult.new(true, []))
        f2 = instance_double(StateMachineChecker::CTL::EX)
        allow(f2).to receive(:check).and_return(f2_result)

        model = instance_double(StateMachineChecker::LabeledMachine, states: Set[:a])

        result = described_class.new([f1, f2]).check(model)
        expect(result.for_state(:a)).to have_attributes(satisfied?: true, witness: path)
      end
    end
  end
end
