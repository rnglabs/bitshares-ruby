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
      blockchain.rpc.request('get_assets',[assets_ids])
    end

    def self.get_many(blockchain, symbols)
      self.get_data(blockchain, symbols).collect do |asset_data|
        self.from_data(self, asset_data)
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
  end
end
