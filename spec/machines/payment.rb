require "state_machines"

# https://github.com/spree/spree/blob/b5d43b527109144c2094fcdff8333d2e2f9076c3/core/app/models/spree/payment.rb
class Payment
  state_machine initial: :checkout do
    event :started_processing do
      transition from: [:checkout, :pending, :completed, :processing], to: :processing
    end
    event :failure do
      transition from: [:pending, :processing], to: :failed
    end
    event :pend do
      transition from: [:checkout, :processing], to: :pending
    end
    event :complete do
      transition from: [:processing, :pending, :checkout], to: :completed
    end
    event :void do
      transition from: [:pending, :processing, :completed, :checkout], to: :void
    end
    event :invalidate do
      transition from: [:checkout], to: :invalid
    end
  end
end
