module StateMachineChecker
  # A transition from one state to another
  class Transition
    attr_reader :from, :to, :name

    # @param [Symbol] from the starting state.
    # @param [Symbol] to the ending state.
    # @param [Symbol] name the name of the transition.
    def initialize(from, to, name)
      @from = from
      @to = to
      @name = name
    end

    # Execute the transition on an instance.
    #
    # This assumes that the instance has a method corresponding to the
    # transition name, and that that will return a boolean representing whether
    # the transition was successful.
    #
    # @param instance the instance to execute the transition on.
    # @return [true, false] whether the transition succeeded.
    def execute(instance)
      instance.public_send(name)
    end

    def ==(other)
      hash_attributes.all? { |attr|
        other.respond_to?(attr) &&
          other.public_send(attr) == public_send(attr)
      }
    end

    def eql?(other)
      other == self
    end

    def hash
      hash_attributes.map(&:hash).hash
    end

    private

    def hash_attributes
      [:from, :to, :name]
    end
  end
end
