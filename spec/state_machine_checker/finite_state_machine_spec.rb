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

  describe "#traverse" do
    context "when reverse is false" do
      it "yields states reachable from the given state" do
        transitions = [
          trans(:a, :b, :ab),
          trans(:b, :c, :bc),
          trans(:c, :a, :ca),
          trans(:c, :b, :cb),
          trans(:c, :c, :cc),
          trans(:b, :d, :bd),
        ]
        fsm = described_class.new(:a, transitions)

        expect { |b| fsm.traverse(:a, &b) }.to yield_successive_args(
          [:a, []],
          [:b, [:ab]],
          [:c, [:ab, :bc]],
          [:d, [:ab, :bd]]
        )
        expect { |b| fsm.traverse(:c, &b) }.to yield_successive_args(
          [:c, []],
          [:a, [:ca]],
          [:b, [:ca, :ab]],
          [:d, [:ca, :ab, :bd]]
        )
      end
    end

    context "when reverse is true" do
      it "yields states from which the given state is reachable" do
        transitions = [
          trans(:a, :b, :ab),
          trans(:b, :c, :bc),
          trans(:c, :a, :ca),
          trans(:c, :b, :cb),
          trans(:c, :c, :cc),
          trans(:b, :d, :bd),
        ]
        fsm = described_class.new(:a, transitions)

        expect { |b| fsm.traverse(:a, reverse: true, &b) }.to yield_successive_args(
          [:a, []],
          [:c, [:ca]],
          [:b, [:bc, :ca]]
        )
        expect { |b| fsm.traverse(:d, reverse: true, &b) }.to yield_successive_args(
          [:d, []],
          [:b, [:bd]],
          [:a, [:ab, :bd]],
          [:c, [:ca, :ab, :bd]]
        )
      end
    end
  end
end
