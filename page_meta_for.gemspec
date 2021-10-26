# frozen_string_literal: true

require_relative "lib/page_meta_for/version"

Gem::Specification.new do |spec|
  spec.name          = "page_meta_for"
  spec.version       = PageMetaFor::VERSION
  spec.authors       = ["Alexey Osipenko"]
  spec.email         = ["alexey@cimon.io"]

  spec.summary       = "Controller level method to define the part of the meta tags"
  spec.description   = "Then views and layouts are able to call `page_meta_for` which can be defined on controller level via `page_meta` class method."
  spec.homepage      = "https://github.com/cimon-io/page_meta_for"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/cimon-io/page_meta_for"
  spec.metadata["changelog_uri"] = "https://github.com/cimon-io/page_meta_for/commits"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_dependency 'activesupport'
  spec.add_dependency 'actionpack'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'simplecov'

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
