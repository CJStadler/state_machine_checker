require "./spec/machines/simple_machine"

RSpec.describe StateMachineChecker do
  it "has a version number" do
    expect(StateMachineChecker::VERSION).not_to be nil
  end

  describe "#check_satisfied" do
    context "when the formula is satisfied" do
      it "is satisfied" do
        true_formulae = [
          EF(:two?),
          EF(:one?),
          EX(:two?),
          EF(atom(:one?).and(EX(:two?))),
          EF(atom(:one?).or(:two?)),
          EF(neg(:one?)),
          neg(EF(->(x) { false })),
          EG(->(x) { true }),
          EG(EF(:two?)),
          AG(->(x) { true }),
          AF(:two?),
          AX(:two?),
          atom(:one?).EU(:two?),
          atom(:one?).AU(:two?),
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
          EX(:one?),
          neg(EX(:two?)),
          EF(->(x) { false }),
          EF(atom(:one?).and(:two?)),
          EG(:one?),
          EG(:two?),
          EF(EG(:two?)),
          AG(EF(:one?)),
          AX(:one?),
          atom(->(x) { true }).EU(->(x) { false }),
          atom(->(x) { true }).AU(->(x) { false }),
        ]

        false_formulae.each do |formula|
          result = check_satisfied(formula, -> { SimpleMachine.new })
          expect(result).not_to be_satisfied
        end
      end
    end
  end
end
