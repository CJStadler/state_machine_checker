# A check whether a given model satisfies a given formula.
class StateMachineChecker::Check
  def initialize(formula, model_generator)
    @formula = formula
    @model_generator = model_generator
  end

  def satisfied?
    false
  end

  def counterexample
  end

  private

  attr_reader :formula, :model_generator
end
