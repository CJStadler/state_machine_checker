module StateMachineChecker
  module CTL
    # The existential universal operator.
    class EG < UnaryOperator
      # Check which states of the model have a path for which the subformula is
      # always satisfied
      #
      # @param [LabeledMachine] model
      # @return [CheckResult]
      def check(model)
        subresult = subformula.check(model)
        projection = subformula_projection(model, subresult)
        scc = strongly_connected_components(projection)

        # Components must have more than one element, a self loop, or no
        # transitions in the original fsm.
        # TODO: this being necessary probably means we're doing something wrong.
        scc.select! do |states|
          states.length > 1 ||
            begin
              c = states.first
              transitions = model.transitions_from(c)

              transitions.empty? ||
                transitions.any? { |t| t.to == c }
            end
        end

        build_check_result(scc, model, projection)
      end

      def to_s
        "EG #{subformula}"
      end

      private

      # A graph containing only states for which the subformula is true.
      def subformula_projection(model, subresult)
        transitions = model.transitions.select { |t|
          subresult.for_state(t.from).satisfied? &&
            subresult.for_state(t.to).satisfied?
        }

        FiniteStateMachine.new(model.initial_state, transitions)
      end

      # Implements Kosaraju's algorithm.
      def strongly_connected_components(projection)
        visited = Set.new
        l = []

        projection.states.each do |s|
          visit(s, visited, l, projection)
        end

        assigned = Set.new
        assignments = {} # root -> set of states in component
        l.reverse_each do |s|
          assign(s, s, assigned, assignments, projection)
        end

        assignments.values
      end

      def build_check_result(scc, model, projection)
        # Initialize hash with every state unsatisfied.
        result = model.states.each_with_object({}) { |s, h|
          h[s] = StateResult.new(false, [])
        }

        scc.each do |component_states|
          # For each state of the component search backwards.
          component_states.each do |state|
            loop_witness = scc_loop(component_states, state, projection)

            projection.traverse(state, reverse: true) do |s, transitions|
              # Ignore other states in the component.
              if s == state || !component_states.include?(s)
                result[s] = StateResult.new(true, transitions + loop_witness)
              else
                false
              end
            end
          end
        end

        CheckResult.new(result)
      end

      # Find a series of transitions within the component_states which start and
      # end with the given state.
      def scc_loop(component_states, start, model)
        model.traverse(start) do |state, path|
          # Only search within the component states.
          if component_states.include?(state)
            transitions = model.transitions_from(state)
            to_start = transitions.find { |t| t.to == start }

            if to_start
              return path.push(to_start.name)
            else
              true # continue
            end
          else
            false
          end
        end

        []
      end

      def visit(s, visited, l, projection)
        unless visited.include?(s)
          visited << s
          projection.transitions_from(s).each do |transition|
            visit(transition.to, visited, l, projection)
          end
          l << s
        end
      end

      def assign(s, root, assigned, assignments, projection)
        unless assigned.include?(s)
          assigned << s

          if assignments[root].nil?
            assignments[root] = Set.new
          end
          assignments[root] << s

          projection.transitions_to(s).each do |transition|
            assign(transition.from, root, assigned, assignments, projection)
          end
        end
      end
    end
  end
end
