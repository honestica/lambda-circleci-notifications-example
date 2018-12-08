require_relative '../circleci-notifications'

require 'rspec'
require 'webmock/rspec'
require 'awesome_print'

RSpec.configure do |config|
  config.order = :random

  WebMock.disable_net_connect!
end
