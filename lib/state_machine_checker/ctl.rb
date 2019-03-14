require "state_machine_checker/ctl/and"
require "state_machine_checker/ctl/atom"
require "state_machine_checker/ctl/or"

module StateMachineChecker
  module CTL
    #    def AG(subformula) # rubocop:disable Naming/MethodName
    #      FormAG.new(subformula)
    #    end
    #
    #    def AF(subformula) # rubocop:disable Naming/MethodName
    #      FormAF.new(subformula)
    #    end
    #
    #    def EG(subformula) # rubocop:disable Naming/MethodName
    #      FormEG.new(subformula)
    #    end
    #
    #    def EF(subformula) # rubocop:disable Naming/MethodName
    #      FormEF.new(subformula)
    #    end

    def and(*subformulae)
      And.new(subformulae)
    end

    def atom(method_name_or_fn)
      Atom.new(method_name_or_fn)
    end

    def or(*subformulae)
      Or.new(subformulae)
    end
  end
end
