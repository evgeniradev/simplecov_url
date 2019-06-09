# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

require 'simplecov_url/version'

Gem::Specification.new do |spec|
  spec.name          = 'simplecov_url'
  spec.version       = SimplecovUrl::VERSION
  spec.authors       = ['Evgeni Radev']
  spec.email         = ['evgeniradev@gmail.com']
  spec.summary       =
    "The gem publishes Simplecov's test coverage reports to your_url/simplecov."
  spec.homepage      = 'https://github.com/evgeniradev/simplecov_url'
  spec.license       = 'MIT'

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.require_paths = ['lib']
  spec.files = Dir[
    '{app,config,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md'
  ]

  spec.add_dependency 'rails', '>= 5.0.3'
  spec.add_dependency 'simplecov', '~> 0.16.1'
  spec.add_dependency 'simplecov-html', '~> 0.10.0'
  spec.add_development_dependency 'rspec', '~> 3.8'
  spec.add_development_dependency 'rubocop-rails', '~> 2.0'
end
