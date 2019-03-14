RSpec.describe StateMachineChecker do
  it "has a version number" do
    expect(StateMachineChecker::VERSION).not_to be nil
  end

  it "checks a simple machine" do
    formula = atom(:present?)
    result = check_satisfied(formula, -> { SimpleMachine.new })
    expect(result).to be_satisfied
  end
end
