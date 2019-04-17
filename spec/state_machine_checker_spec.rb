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
          EF(atom(:one?).and(EX(atom(:two?)))),
#          EF(atom(:one?).or(atom(:two?))),
          EF(atom(:one?).not),
          EF(atom(->(x) { false })).not,
          EG(atom(->(x) { true })),
#          AG(atom(->(x) { true })),
#          AF(atom(:two?)),
#          AX(atom(:two?)),
#          atom(:one?).EU(atom(:two?)),
#          atom(:one?).AU(atom(:two?)),
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
          EX(atom(:two?)).not,
          EF(atom(->(x) { false })),
          EF(atom(:one?).and(atom(:two?))),
          EG(atom(:one?)),
          EG(atom(:two?)),
          EF(EG(atom(:two?))),
          EG(EF(atom(:two?))),
#          AG(EF(atom(:one?))),
#          AX(atom(:one?)),
#          atom(->(x) { true }).EU(atom(->(x) { false })),
#          atom(->(x) { true }).AU(atom(->(x) { false })),
        ]

        false_formulae.each do |formula|
          result = check_satisfied(formula, -> { SimpleMachine.new })
          expect(result).not_to be_satisfied
        end
      end
    end
  end
end
