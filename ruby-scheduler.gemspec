require_relative 'lib/ruby/scheduler/version'

Gem::Specification.new do |spec|
  spec.name          = "ruby-scheduler"
  spec.version       = Ruby::Scheduler::VERSION
  spec.authors       = ["Alexander Dewhirst"]
  spec.email         = ["alexander.b.dewhirst@gmail.com"]

  spec.summary       = %q{"Create a meeting scheduler for a standard business day with meetings provided"}
  spec.homepage      = "https://github.com/AlexanderDewhirst/ruby_scheduler"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir['[A-Z]*[^~]'] + Dir['helpers/*.rb'] + Dir['lib/**/*.rb'] + Dir['lib/**/**/*.rb'] + Dir['spec/*'] + ['.gitignore']
  spec.test_files    = Dir['spec/*']
  # spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
  #   `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  # end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib", "helpers"]

  spec.add_development_dependency 'rspec', '>= 3.0.0'
  spec.add_development_dependency 'rake', '~> 12.3.2'
end
