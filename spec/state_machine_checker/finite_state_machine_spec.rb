require "./lib/state_machine_checker/finite_state_machine.rb"
require "./lib/state_machine_checker/transition.rb"
require "./spec/machines/simple_machine.rb"
require "./spec/machines/cyclic_machine.rb"

RSpec.describe StateMachineChecker::FiniteStateMachine do
  describe "#state_paths" do
    context "for a simple machine" do
      it "yields each state and a path to it" do
        transitions = [StateMachineChecker::Transition.new(:a, :b, :ab)]
        fsm = described_class.new(:a, transitions)

        paths = fsm.state_paths.each_with_object({}) { |(state, path), h|
          h[state] = path.map(&:name)
        }

        expect(paths).to eq(a: [], b: [:ab])
      end
    end

    context "for a complex machine" do
      it "yields each state and a path to it" do
        transitions = [
          StateMachineChecker::Transition.new(:a, :b, :ab),
          StateMachineChecker::Transition.new(:b, :c, :bc),
          StateMachineChecker::Transition.new(:c, :a, :ca),
          StateMachineChecker::Transition.new(:c, :b, :cb),
          StateMachineChecker::Transition.new(:c, :c, :cc),
          StateMachineChecker::Transition.new(:b, :d, :bd),
        ]
        fsm = described_class.new(:a, transitions)

        paths = fsm.state_paths.each_with_object({}) { |(state, path), h|
          h[state] = path.map(&:name)
        }

        expect(paths).to eq(a: [], b: [:ab], c: [:ab, :bc], d: [:ab, :bd])
      end
    end
  end

  describe "#states" do
    it "yields the name of each state" do
      fsm = CyclicMachine.finite_state_machine
      expect(fsm.states).to contain_exactly(:a, :b, :c, :d, :e)
    end
  end

  describe "#predecessor_states" do
    it "returns states from which the given state is reachable" do
      transitions = [
        StateMachineChecker::Transition.new(:a, :b, :ab),
        StateMachineChecker::Transition.new(:b, :c, :bc),
        StateMachineChecker::Transition.new(:c, :a, :ca),
        StateMachineChecker::Transition.new(:c, :b, :cb),
        StateMachineChecker::Transition.new(:c, :c, :cc),
        StateMachineChecker::Transition.new(:b, :d, :bd),
      ]
      fsm = described_class.new(:a, transitions)

      expect(fsm.predecessor_states(:a)).to contain_exactly(:a, :b, :c)
      expect(fsm.predecessor_states(:b)).to contain_exactly(:a, :b, :c)
      expect(fsm.predecessor_states(:c)).to contain_exactly(:a, :b, :c)
      expect(fsm.predecessor_states(:d)).to contain_exactly(:a, :b, :c)
    end
  end

  context "when a predicate is provided" do
    it "returns states from which the given state is reachable while the predicate is always true" do
      transitions = [
        StateMachineChecker::Transition.new(:a, :b, :ab),
        StateMachineChecker::Transition.new(:b, :c, :bc),
        StateMachineChecker::Transition.new(:c, :d, :cd),
      ]
      fsm = described_class.new(:a, transitions)
      result = fsm.predecessor_states(:d) { |s| s == :c || s == :a }
      expect(result).to contain_exactly(:c)
    end
  end
end
