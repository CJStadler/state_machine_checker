# A check whether a given model satisfies a given formula.
class StateMachineChecker::Check
  def initialize(formula, machine, instance_generator)
    @formula = formula
    @machine = machine
    @instance_generator = instance_generator
  end

  def kripke_structure
    @kripke_structure ||= KripkeStructure.new(
      machine.initial,
      machine.transitions,
      Labeling.new(formula.atoms, machine, instance_generator)
    )
  end

  def satisfied?
    formula.satisfied_by?(kripke_structure)
  end

  def counterexample
    # TODO
  end

  private

  attr_reader :formula, :instance_generator, :machine

end
