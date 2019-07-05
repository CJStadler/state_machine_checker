# State Machine Checker

Verify (as in prove) properties of your state machines.

Given a definition of a state machine and a CTL formula this library performs
model checking to verify whether the formula is satisfied by the state machine.

For example, let's say we have implemented a very simple state machine to
represent credit card payments:

```rb
class Payment
  state_machine initial: :checkout do
    event :started_processing do
      transition from: [:checkout], to: :processing
    end

    event :finished_processing do
      transition from: [:processing], to: :completed
    end

    event :processing_failed do
      transition from: [:processing], to: :failed
    end
  end
end
```

We might want to verify that every `Payment` eventually completes. This property
can  be represented as the CTL Formula `AF completed` — for all paths (`A`)
eventually (`F`) `completed` is true. `state_machine_checker` includes a DSL for
writing CTL properties and a `rspec` matcher, so we can write a spec to verify
this property:

```rb
it "eventually completes" do
  formula = AF(:completed?)
  expect { Payment.new }.to satisfy(formula)
end
```

This spec will fail and give the following message:

```
1) Payment eventually completes
     Failure/Error: expect { Payment.new }.to satisfy(formula)

       Expected state machine for Payment#state to satisfy "AF(completed?)" but it does not.
       Counterexample: [:started_processing, :processing_failed]
```

A counterexample is given as a series of events: if `started_processing` is
followed by `processing_failed` then a `Payment` will be in the `failed` state
and will never reach `completed`.

For more examples see [https://github.com/CJStadler/state_machine_checker/blob/master/spec/payment_spec.rb].

## Limitations

- The state machine must be static — once the definition is parsed no states or
  transitions should be added or removed.
- Atoms should only depend on the current state.
- Only the [state_machines](https://rubygems.org/gems/state_machines) gem is
  currently supported, but adapters for other state machine gems could be added.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'state_machine_checker'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install state_machine_checker

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/CJStadler/state_machine_checker. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the StateMachineChecker project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/CJStadler/state_machine_checker/blob/master/CODE_OF_CONDUCT.md).
