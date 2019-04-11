module StateMachineChecker
  # The result of checking whether this state satisfies a formula.
  class StateResult
    # @param [Boolean] satisfied
    # @param [Array<Symbol>] path
    def initialize(satisfied, path)
      @satisfied = satisfied
      @path = path
    end

    # Whether the formula is satisfied from this state.
    #
    # @return [true, false]
    def satisfied?
      satisfied
    end

    # A witness that the formula is satisfied from this state.
    #
    # @return [Array<Symbol>] an array of the names of transitions.
    def witness
      if satisfied?
        path
      end
    end

    # A counterexample demonstrating that the formula is not satisfied from this
    # state.
    #
    # @return [Array<Symbol>] an array of the names of transitions.
    def counterexample
      unless satisfied?
        path
      end
    end

    private

    attr_reader :satisfied, :path
  end
end
