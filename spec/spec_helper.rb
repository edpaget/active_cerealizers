require "bundler/setup"
Bundler.require(:development)

#Dir['spec/support/examples/*.rb'].each do |file|
  #require_relative file
#end

require 'support/database'

Database.connect

RSpec.configure do |config|
  config.disable_monkey_patching!
end
