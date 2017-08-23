module Bitshares

  class Asset
    class Err < RuntimeError; end

    attr_reader :asset

    def initialize(blockchain, name=nil)
      @blockchain = blockchain
      @asset = Asset.get_data(@blockchain, [name]).first if name
    end

    def self.get_data(blockchain, symbols)
      symbols = Bitshares::Helpers.to_array(symbols)
      symbols.map(&:upcase!)
      found_assets = blockchain.lookup_asset_symbols symbols
      raise Err, "Invalid asset: #{symbols}" if found_assets.nil? || found_assets.any?(&:nil?)
      assets_ids = found_assets.collect{|a| a['id']}
      raise Err, "Invalid asset: #{symbols}" if assets_ids.count != symbols.count
      self.get_data_by_ids(blockchain, assets_ids)
    end

    def self.get_data_by_ids(blockchain, assets_ids)
      blockchain.rpc.request('get_assets',[assets_ids])
    end

    def self.get_many(blockchain, symbols)
      self.get_data(blockchain, symbols).collect do |asset_data|
        self.from_data(blockchain, asset_data)
      end
    end

    def self.get_many_by_ids(blockchain, assets_ids)
      self.get_data_by_ids(blockchain, assets_ids).collect do |asset_data|
        self.from_data(blockchain, asset_data)
      end
    end

    def self.from_data(blockchain, data)
      instance = self.new(blockchain)
      instance.set_data(data)
      instance
    end

    def set_data(data)
      @asset = data
    end

    def method_missing(m, *args)
      @asset[m.to_s]
    end

    def bitasset_data
      @blockchain.get_objects([bitasset_data_id]).first if bitasset_data_id
    end

    def feeds
      bitasset_data['feeds']
    end

    def feeds_settlement_prices
      feeds.collect{|f| f[1][1]['settlement_price']['base']['amount'] }.sort
    end

    def feeds_core_exchange_rates
      feeds.collect{|f| f[1][1]['core_exchange_rates']['base']['amount'] }.sort
    end

    def current_feed
      bitasset_data['current_feed']
    end

    def bts
      @bts ||= @blockchain.asset('bts').first
    end

    def settlement_price
      multiplier * current_feed['settlement_price']['base']['amount'].to_f / current_feed['settlement_price']['quote']['amount']
    end

    def multiplier
      (10 ** (bts.precision - precision))
    end

    def dynamic_asset_data
      @blockchain.get_objects([dynamic_asset_data_id]).first
    end
  end
end
