lib = File.expand_path('../lib', __FILE__)

$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'attachy/version'

Gem::Specification.new do |spec|
  spec.author      = 'Washington Botelho'
  spec.description = 'Attachments handler for Rails via Cloudinary.'
  spec.email       = 'wbotelhos@gmail.com'
  spec.files       = Dir['lib/**/*'] + %w[CHANGELOG.md LICENSE README.md]
  spec.homepage    = 'https://github.com/wbotelhos/attachy'
  spec.license     = 'MIT'
  spec.name        = 'attachy'
  spec.platform    = Gem::Platform::RUBY
  spec.summary     = 'Attachments handler for Rails via Cloudinary.'
  spec.test_files  = Dir['spec/**/*']
  spec.version     = Attachy::VERSION

  spec.add_dependency 'cloudinary', '~> 1'
  spec.add_dependency 'rails'     , '~> 5'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'database_cleaner'
  spec.add_development_dependency 'factory_girl_rails'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'rails-controller-testing'
  spec.add_development_dependency 'rspec-html-matchers'
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop-rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'shoulda-matchers'
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'pry-byebug'
end
