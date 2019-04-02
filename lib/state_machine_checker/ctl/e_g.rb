module StateMachineChecker
  module CTL
    # The existential universal operator.
    class EG < UnaryOperator
      # the states from which there is a path for which the subformula is always
      # true.
      #
      # @param [LabeledMachine] model
      # @return [Set<Symbol>]
      def satisfying_states(model)
        states, out_edges, in_edges = subformula_projection(model)
        scc = strongly_connected_components(states, out_edges, in_edges)

        # Components must have more than one element, a self loop, or no
        # transitions in the original fsm.
        # TODO: this being necessary probably means we're doing something wrong.
        scc.select! do |components|
          c = components.first
          components.length > 1 ||
            out_edges[c].include?(c) ||
            !model.transitions.any? { |t| t.from == c }
        end
        backwards_reachable_from(scc, in_edges)
      end

      private

      # A graph containing only states for which the subformula is true.
      def subformula_projection(model)
        states = subformula.satisfying_states(model)
        out_edges = states.each_with_object({}) { |s, h| h[s] = Set.new }
        in_edges = states.each_with_object({}) { |s, h| h[s] = Set.new }

        model.transitions.each do |t|
          if states.include?(t.from) && states.include?(t.to)
            out_edges[t.from] << t.to
            in_edges[t.to] << t.from
          end
        end
        [states, out_edges, in_edges]
      end

      # Implements Kosaraju's algorithm.
      def strongly_connected_components(states, out_edges, in_edges)
        visited = Set.new
        l = []

        states.each do |s|
          visit(s, visited, l, out_edges)
        end

        assigned = Set.new
        assignments = {} # root -> components set
        l.reverse_each do |s|
          assign(s, s, assigned, assignments, in_edges)
        end

        assignments.values
      end

      def backwards_reachable_from(scc, in_edges)
        reachable = Set.new

        scc.each do |components|
          components.each do |s|
            reverse_search(s, reachable, in_edges)
          end
        end

        reachable
      end

      def reverse_search(s, reachable, in_edges)
        unless reachable.include?(s)
          reachable << s

          in_edges[s].each do |neighbor|
            reverse_search(neighbor, reachable, in_edges)
          end
        end
      end

      def visit(s, visited, l, out_edges)
        unless visited.include?(s)
          visited << s
          out_edges[s].each do |neighbor|
            visit(neighbor, visited, l, out_edges)
          end
          l << s
        end
      end

      def assign(s, root, assigned, assignments, in_edges)
        unless assigned.include?(s)
          assigned << s

          if assignments[root].nil?
            assignments[root] = Set.new
          end
          assignments[root] << s

          in_edges[s].each do |neighbor|
            assign(neighbor, root, assigned, assignments, in_edges)
          end
        end
      end
    end
  end
end
