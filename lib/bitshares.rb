require 'bitshares/version'

require 'json'
require 'uri'
require 'net/http'
require 'yaml'

require 'bitshares/rpc'
require 'bitshares/rpcmagic'
require 'bitshares/client'
require 'bitshares/wallet'
require 'bitshares/market'

# stackoverflow.com/questions/6233124/where-to-place-access-config-file-in-gem
module Bitshares
  @defaults = {rpc: {username: nil, password: nil, server: 'http://127.0.0.1:8090/'}, wallet: {name: nil, password: nil}}
  @config = @defaults

  def self.configure(opts = {})
    # Assign only whitelisted config params
    opts.each do |key,value|
      key = key.to_sym
      if @defaults.keys.include? key
        if value.is_a? Hash
          @config[key].merge! value.select{|field,_| @defaults[key].keys.include?(field.to_sym) }
        else
          @config[key] = value
        end
      end
    end

    # ENV vars override other configs
    @config[:rpc][:username] = ENV['BITSHARES_ACCOUNT'] || @config[:rpc][:username]
    @config[:rpc][:password] = ENV['BITSHARES_PASSWORD'] || @config[:rpc][:password]
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

  def self.openledger
    configure(rpc: { server: "https://bitshares.openledger.info/ws" })
    init
  end

  def self.testnet
    configure(rpc: { server: "https://node.testnet.bitshares.eu/" })
    init
  end

  def self.init
    Bitshares::Client.new(config)
  end
end
