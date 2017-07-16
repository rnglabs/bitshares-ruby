module Bitshares

  class Blockchain
    include RPC

    def get_assets(*symbols)
      symbols = [symbols] unless symbols.respond_to? :each
      symbols.map(&:upcase!)
      found_assets = lookup_asset_symbols symbols
      raise Err, "Invalid asset: #{symbols}" if found_assets.nil? || found_assets.empty?
      assets_ids = found_assets.collect{|a| a['id']}
      raise Err, "Invalid asset: #{symbols}" if assets_ids.count != symbols.count

      CLIENT.get_assets(assets_ids)
    end
    alias_method :get_asset, :get_assets
    alias_method :assets, :get_assets
    alias_method :asset, :get_assets

  end

end
