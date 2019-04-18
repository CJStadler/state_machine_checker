require "state_machine_checker/ctl/atom"
require "state_machine_checker/ctl/and"
require "state_machine_checker/ctl/not"
require "state_machine_checker/labeled_machine"
require "state_machine_checker/check_result"
require "state_machine_checker/state_result"

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

  describe "#check" do
    it "marks states as satisfied which are not satisfied by the subformula" do
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
      result = not1.check(machine)
      expect(result.for_state(:a)).to have_attributes(satisfied?: false, counterexample: [])
      expect(result.for_state(:b)).to have_attributes(satisfied?: true, witness: [])
      expect(result.for_state(:c)).to have_attributes(satisfied?: true, witness: [])
    end

    context "when the subformula provides a witness" do
      it "turns witnesses into counterexamples" do
        path = instance_double(Array)
        sub_result = StateMachineChecker::CheckResult
          .new(a: StateMachineChecker::StateResult.new(true, path))

        subformula = instance_double(StateMachineChecker::CTL::EF)
        allow(subformula).to receive(:check).and_return(sub_result)

        model = instance_double(StateMachineChecker::LabeledMachine, states: Set[:a])

        result = described_class.new(subformula).check(model)
        expect(result.for_state(:a)).to have_attributes(satisfied?: false, counterexample: path)
      end
    end

    context "when the subformula provides a counterexample" do
      it "turns counterexamples into witnesses" do
        path = instance_double(Array)
        sub_result = StateMachineChecker::CheckResult
          .new(a: StateMachineChecker::StateResult.new(false, path))

        subformula = instance_double(StateMachineChecker::CTL::Not)
        allow(subformula).to receive(:check).and_return(sub_result)

        model = instance_double(StateMachineChecker::LabeledMachine, states: Set[:a])

        result = described_class.new(subformula).check(model)
        expect(result.for_state(:a)).to have_attributes(satisfied?: true, witness: path)
      end
    end
  end

  describe "#to_s" do
    it "returns the formula as a string" do
      atom = StateMachineChecker::CTL::Atom.new(:foo?)
      f = described_class.new(atom)
      expect(f.to_s).to eq("¬ foo?")
    end
  end
end
