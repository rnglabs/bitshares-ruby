module Bitshares

  class Market

    include RPC

    attr_reader :base, :quote

    DATE_FORMAT = '%FT%R'.freeze

    def initialize(base, quote)
      @base_hash, @quote_hash = CHAIN.get_assets(base, quote)
      @base, @quote = @base_hash['symbol'], @quote_hash['symbol']
      valid_market?(@base_hash['id'], @quote_hash['id'])
      @multiplier = multiplier
    end

    def ticker
      CLIENT.get_ticker(@base, @quote)
    end

    def lowest_ask
      ticker['lowest_ask']
    end

    def highest_bid
      ticker['highest_bid']
    end

    def mid_price
      return nil if highest_bid.nil? || lowest_ask.nil?
      (highest_bid + lowest_ask) / 2

    def get_order_book(limit=50)
      CLIENT.get_order_book(@base, @quote, limit)
    end

    def get_limit_orders(limit=50)
      CLIENT.get_limit_orders(@base, @quote, limit)
    end

    def get_trade_history(since=nil,to=nil,limit=100)
      since ||= Date.new(1970,1,1)
      to ||= Date.today
      CLIENT.get_trade_history(@base, @quote,
          since.strftime(DATE_FORMAT),
          to.strftime(DATE_FORMAT), limit)
    end

    def get_24_volume
      CLIENT.get_24_volume(@base, @quote)
    end

    # OLD PORTING
    def last_fill
      return -1 if order_hist.empty?
      order_hist.first['bid_index']['order_price']['ratio'].to_f * multiplier
    end

    def list_shorts(limit = nil) # uses quote only, not base
      CLIENT.request('blockchain_market_list_shorts', [quote] + [limit])
    end

    def get_asset_collateral # uses quote only, not base
      CLIENT.request('blockchain_market_get_asset_collateral', [quote])
    end

    def price(order) # CARE: preserve float precision with * NOT /
      order['market_index']['order_price']['ratio'].to_f * @multiplier
    end

    private

    def valid_market?(quote_id, base_id)
      raise Err, 'Invalid market; quote ID <= base ID' if quote_id <= base_id
    end

    def multiplier
      @base_hash['precision'].to_f / @quote_hash['precision']
    end

    def method_prefix
      'blockchain_market_'
    end

    def default_args
      [quote, base]
    end
  end
end
