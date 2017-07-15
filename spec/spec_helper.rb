$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'bitshares'

Bitshares.configure(rpc_server: "https://bitshares.openledger.info/ws")

include_cost = ENV['BITSHARES_INCLUDE_TESTS_WITH_COSTS'] == 'true'
RSpec.configure { |c| c.filter_run_excluding :type => 'cost' } if !include_cost
