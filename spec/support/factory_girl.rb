require 'factory_girl'

Dir[File.expand_path('../factories/**/*.rb', __dir__)].each { |file| require file }

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end
