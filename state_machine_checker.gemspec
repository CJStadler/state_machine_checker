lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "state_machine_checker/version"

Gem::Specification.new do |spec|
  spec.name          = "state_machine_checker"
  spec.version       = StateMachineChecker::VERSION
  spec.authors       = ["Chris Stadler"]
  spec.email         = ["chrisstadler@gmail.com"]

  spec.summary       = "Model checking for state machines using CTL."
  spec.description   = <<~DESC
    Verify properties of your state machines.
  DESC
  spec.homepage      = "https://github.com/CJStadler/state_machine_checker"
  spec.license       = "MIT"

  if spec.respond_to?(:metadata)
    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/CJStadler/state_machine_checker"
    spec.metadata["changelog_uri"] =
      "https://github.com/CJStadler/state_machine_checker/blob/master/CHANGELOG.md"
    spec.metadata["documentation_uri"] = "https://www.rubydoc.info/github/CJStadler/state_machine_checker"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path("..", __FILE__)) do
    `git ls-files -z`.split("\x0")
      .reject { |f| f.match(%r{^(test|spec|features)/}) }
      .reject { |f| f.match("paper.pdf")}
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "state_machines", "~> 0.5.0"
  spec.add_development_dependency "standard", "~> 0.0.36"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "yard", ">= 0.9.20"
end
