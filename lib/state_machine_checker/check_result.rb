module StateMachineChecker
  # The results of checking whether a given model satisfies a given formula.
  class CheckResult
    # @param [Hash<Symbol, StateResult>] result_hash
    def initialize(result_hash)
      @result_hash = result_hash
    end

    # The result for a particular state.
    #
    # @param [Symbol] state
    # @return [StateResult]
    def for_state(state)
      result_hash[state]
    end

    def to_h
      result_hash.clone
    end

    def union(other)
      map { |state, result| result.or(other.for_state(state)) }
    end

    def intersection(other)
      map { |state, result| result.and(other.for_state(state)) }
    end

    def map(&block)
      entries = result_hash.map { |state, result|
        [state, block.yield(state, result)]
      }
      CheckResult.new(Hash[entries])
    end

    private

    attr_reader :result_hash
  end
end
