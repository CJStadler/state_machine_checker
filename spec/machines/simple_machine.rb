require "state_machines"

class SimpleMachine
  state_machine initial: :one do
    event :go do
      transition one: :two
    end
  end
end
