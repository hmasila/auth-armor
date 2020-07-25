require_relative 'lib/auth/armor/version'

Gem::Specification.new do |spec|
  spec.name          = "auth-armor"
  spec.version       = AuthArmor::VERSION
  spec.authors       = ["Hannah Masila"]
  spec.email         = ["hannahmasila@gmail.com"]

  spec.summary       = %q{AuthArmor is Password-less login and 2FA using biometrics secured by hardware and PKI.}
  spec.description   = %q{This library provides convenient access to the AuthArmor API from applications written in the Ruby language. It includes a pre-defined set of methods for API resources that initialize themselves dynamically from API responses.}
  spec.homepage      = "https://rubygems.org/gems/auth-armor"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/hmasila/auth-armor"
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.1.4"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_dependency "rest-client"
end
