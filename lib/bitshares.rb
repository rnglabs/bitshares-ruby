require 'bitshares/version'

require 'json'
require 'uri'
require 'net/http'
require 'yaml'

require 'bitshares/rpc'
require 'bitshares/client'
require 'bitshares/blockchain'
require 'bitshares/wallet'
require 'bitshares/account'
require 'bitshares/market'
require 'bitshares/trader'

CLIENT = Bitshares::Client.new
CHAIN = Bitshares::Blockchain.new

# stackoverflow.com/questions/6233124/where-to-place-access-config-file-in-gem
module Bitshares

  @config = {rpc_username: nil, rpc_password: nil, rpc_server: 'http://127.0.0.1:8090/', wallet: nil}

  @valid_keys = @config.keys

  def self.configure(opts = {})
    opts.each {|k,v| @config[k.to_sym] = v if @valid_keys.include? k.to_sym}

    # ENV vars override other configs
    @config[:rpc_username] = ENV['BITSHARES_ACCOUNT'] || @config[:rpc_username]
    @config[:rpc_password] = ENV['BITSHARES_PASSWORD'] || @config[:rpc_password]
  end

  def self.configure_with(path_to_yaml_file)
    begin
      config = YAML::load(IO.read(path_to_yaml_file))
    rescue Errno::ENOENT
      puts "YAML configuration file couldn\'t be found. Using defaults"
      return
    rescue Psych::SyntaxError
      puts 'YAML configuration file contains invalid syntax. Using defaults'
      return
    end
    configure(config)
  end

  def self.config
    @config
  end

  def self.wallet_api_enabled?
    config[:wallet].responds_to? :[]
  end

  def self.openledger
    configure(rpc_server: "https://bitshares.openledger.info/ws")
    CLIENT.init
  end

  def self.testnet
    configure(rpc_server: "https://node.testnet.bitshares.eu/")
    CLIENT.init
  end
end
