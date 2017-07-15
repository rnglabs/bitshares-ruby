module Bitshares

  class Blockchain
    include RPC

    def get_asset(*symbols)
      symbols = [symbols] unless symbols.respond_to? :each
      symbols.map(&:upcase!)
      assets = CLIENT.lookup_asset_symbols symbols
      raise Err, "Invalid asset: #{symbols}" if assets.nil?
      assets_ids = assets.collect{|a| a['id']}
      raise Err, "Invalid asset: #{symbols}" if assets_ids.count != symbols.count

      CLIENT.get_assets(assets_ids)
    end
    alias_method :get_assets, :get_asset

    private

    def method_prefix
      'blockchain_'
    end

  end

end
