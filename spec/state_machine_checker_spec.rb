require "./spec/machines/simple_machine"

RSpec.describe StateMachineChecker do
  it "has a version number" do
    expect(StateMachineChecker::VERSION).not_to be nil
  end

  describe "#check_satisfied" do
    context "when the formula is satisfied" do
      it "is satisfied" do
        true_formulae = [
          EF(atom(:two?)),
          EF(atom(:one?)),
          EX(atom(:two?)),
          EF(atom(:one?).or(atom(:two?))),
          EF(atom(:one?).not),
          EF(atom(->(x) { false })).not,
        ]

        true_formulae.each do |formula|
          result = check_satisfied(formula, -> { SimpleMachine.new })
          expect(result).to be_satisfied
        end
      end
    end

    context "when the formula is not satisfied" do
      it "is not satisfied" do
        false_formulae = [
          EX(atom(:one?)),
          EF(atom(->(x) { false })),
          EF(atom(:one?).and(atom(:two?))),
        ]

        false_formulae.each do |formula|
          result = check_satisfied(formula, -> { SimpleMachine.new })
          expect(result).not_to be_satisfied
        end
      end
    end
  end
end
