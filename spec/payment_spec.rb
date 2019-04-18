require "./spec/machines/payment"
require "state_machine_checker/rspec_matchers"

# This is an example of using the custom matcher.
RSpec.describe Payment do
  include StateMachineChecker::RspecMatchers

  it "can reach completed" do
    expect { Payment.new }.to satisfy(EF(:completed?))
  end

  it "can be voided directly from completed" do
    formula = AG(atom(:completed?).implies(EX(:void?)))
    expect { Payment.new }.to satisfy(formula)
  end

  it "can fail after completed" do
    formula = AG(atom(:completed?).implies(neg(EF(:failed?))))
    expect { Payment.new }.not_to satisfy(formula)
  end

  it "has no path from void" do
    formula = AG(atom(:void?).implies(neg(EX(->(_) { true }))))
    expect { Payment.new }.to satisfy(formula)
  end

  it "may never reach a terminal state" do
    terminals = atom(:completed?)
      .or(:failed?)
      .or(:void?)
      .or(:invalid?)
    formula = EF(EG(neg(terminals)))
    expect { Payment.new }.to satisfy(formula)
  end
end
