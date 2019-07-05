require "state_machine_checker/rspec_matchers"
require "state_machines"

class Payment
  state_machine initial: :checkout do
    event :started_processing do
      transition from: [:checkout], to: :processing
    end

    event :finished_processing do
      transition from: [:processing], to: :completed
    end

    event :processing_failed do
      transition from: [:processing], to: :failed
    end
  end
end

RSpec.describe Payment do
  include StateMachineChecker::RspecMatchers

  it "eventually completes" do
    formula = AF(:completed?)
    expect { Payment.new }.to satisfy(formula)
  end
end
