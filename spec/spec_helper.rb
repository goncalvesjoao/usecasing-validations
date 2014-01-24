require 'usecasing_validations'

require 'pry'

Dir.chdir("spec/") do
  Dir["support/models/*.rb"].each { |file| require file }
  Dir["support/usecases/*.rb"].each { |file| require file }
end

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.mock_framework = :mocha

  config.order = 'random'
end
