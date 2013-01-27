# spork/rspec
remove_file 'spec/spec_helper.rb'
create_file 'spec/spec_helper.rb', <<-SPEC
require 'rubygems'
require 'spork'

if(ENV["SIMPLECOV"])
  require 'simplecov'
  SimpleCov.start 'rails' do
    add_filter "/spec/"
  end
  puts "Running coverage tool\\n"
end

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'

  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'

  #{"require 'rails/application'" if @template_options[:devise]}
  #{"Spork.trap_method(Rails::Application::RoutesReloader, :reload!)" if @template_options[:devise]}

  #{"require 'authlogic/test_case'" if @template_options[:authlogic]}
  #{"include Authlogic::TestCase" if @template_options[:authlogic]}

  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    Capybara.javascript_driver = :webkit
    config.mock_with :rspec
    config.fixture_path = "\#{::Rails.root}/spec/factories"
    config.use_transactional_fixtures = false

    config.before(:suite) do
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.clean_with :truncation
    end

    config.before(:each) do
      if example.metadata[:use_truncation]
        DatabaseCleaner.strategy = :truncation
      else
        DatabaseCleaner.start
      end
    end

    config.after(:each) do
      DatabaseCleaner.clean
      if example.metadata[:use_truncation]
        DatabaseCleaner.strategy = :transaction
      end
    end
  end

end

Spork.each_run do
  #{"FactoryGirl.reload" if @template_options[:factory_girl]}
end
SPEC

remove_file 'test'
remove_file 'public/index.html'
remove_file 'app/assets/images/rails.png'

run 'rake db:migrate db:test:clone'