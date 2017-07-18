module Bitshares

  class Client
    class Err < RuntimeError; end
    attr_reader :wallet

    include RPCMagic

    def initialize(config)
      @rpc = Bitshares::RPC.new(config[:rpc])
      # This is a blocking http call that will be called the first time
      @rpc.check_rpc!
      @wallet = Bitshares::Wallet.new(@rpc, config[:wallet])
    end

    def get_assets(*symbols)
      symbols = [symbols] unless symbols.respond_to? :each
      symbols.map(&:upcase!)
      found_assets = lookup_asset_symbols symbols
      raise Err, "Invalid asset: #{symbols}" if found_assets.nil? || found_assets.any?(&:nil?)
      assets_ids = found_assets.collect{|a| a['id']}
      raise Err, "Invalid asset: #{symbols}" if assets_ids.count != symbols.count

      @rpc.request('get_assets',[assets_ids])
    end
    alias_method :get_asset, :get_assets
    alias_method :assets, :get_assets
    alias_method :asset, :get_assets

    def market(base, quote)
      Bitshares::Market.new(self,base,quote)
    end

  end

end
