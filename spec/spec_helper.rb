ENV["RAILS_ENV"] = "test"
$:.unshift File.dirname(__FILE__)
$:.unshift File.expand_path('../lib', __FILE__)

require 'rake'
require 'authlogic'
require 'authlogic_cas'
require 'rails/all'
require 'rspec/rails'
require 'rspec/autorun'

require 'scenario/config/environment'
Altry::Application.load_tasks
Rake::Task["db:migrate"].invoke



RSpec.configure do |config|
  config.mock_with :rspec
  # config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
end
