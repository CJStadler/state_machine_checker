require "./lib/state_machine_checker/finite_state_machine.rb"
require "./lib/state_machine_checker/transition.rb"

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
end
