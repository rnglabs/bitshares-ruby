$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'bitshares'

Bitshares.testnet

include_cost = ENV['BITSHARES_INCLUDE_TESTS_WITH_COSTS'] == 'true'
RSpec.configure { |c| c.filter_run_excluding :type => 'cost' } if !include_cost
