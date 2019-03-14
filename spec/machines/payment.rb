require "state_machines"

class Payment
  state_machine initial: :checkout do
    event :submit do
      transition from: :checkout, to: :processing
    end

    event :failure do
      transition from: :processing, to: :failed
    end

    event :complete do
      transition from: :processing, to: :completed
    end
    after_transition on: :complete, do: :ship_order

    event :void do
      transition from: [:processing, :completed, :checkout], to: :void
    end
  end
end
