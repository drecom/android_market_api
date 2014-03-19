# -*- coding: utf-8 -*-

require "android_market_api"
require "rspec"
require "pry"
require "rspec-parameterized"

require 'coveralls'
Coveralls.wear!

RSpec.configure do |config|
  root_dir = File.expand_path(File.dirname(__FILE__) + "/..")

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in lib/, spec/support/ and its subdirectories.
  Dir["#{root_dir}/lib/support/**/*.rb"].each {|f| require f}
  Dir["#{root_dir}/spec/support/**/*.rb"].each {|f| require f}

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"
end
