module Bitshares

  class Client
    class Err < RuntimeError; end
    attr_reader :wallet, :rpc

    include RPCMagic

    def initialize(config)
      @rpc = Bitshares::RPC.new(config[:rpc])
      # This is a blocking http call that will be called the first time
      @rpc.check_rpc!
      @wallet = Bitshares::Wallet.new(@rpc, config[:wallet])
    end

    def get_assets(*symbols)
      Bitshares::Asset.get_many(self, symbols)
    end
    alias_method :get_asset, :get_assets
    alias_method :assets, :get_assets
    alias_method :asset, :get_assets

    def market(base, quote)
      Bitshares::Market.new(self, base, quote)
    end

    def account(name)
      Bitshares::Account.new(self, name)
    end
  end

end
