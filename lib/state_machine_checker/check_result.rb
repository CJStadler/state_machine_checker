module StateMachineChecker
  # The results of checking whether a given model satisfies a given formula.
  class CheckResult
    # @param [Hash<Symbol, StateResult>] result_hash
    def initialize(result_hash)
      @result_hash = result_hash
    end

    attr_reader :result_hash

    # The result for a particular state.
    #
    # @param [Symbol] state
    # @return [StateResult]
    def for_state(state)
      result_hash[state]
    end

    def to_h
      result_hash
    end
  end
end
