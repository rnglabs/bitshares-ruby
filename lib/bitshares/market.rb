module Bitshares

  class Market
    class Err < RuntimeError; end

    attr_reader :base, :quote

    DATE_FORMAT = '%FT%R'.freeze

    def initialize(blockchain, base, quote)
      @blockchain = blockchain
      @base, @quote = @blockchain.get_assets(base, quote)
      valid!
    end

    def ticker
      @blockchain.get_ticker(@base.symbol, @quote.symbol)
    end

    def lowest_ask
      ticker['lowest_ask']
    end

    def highest_bid
      ticker['highest_bid']
    end

    def mid_price
      return nil if highest_bid.nil? || lowest_ask.nil?
      (highest_bid.to_f + lowest_ask.to_f) / 2
    end

    def order_book(limit=50)
      @blockchain.get_order_book(@base.id, @quote.id, limit)
    end

    def limit_orders(limit=50)
      @blockchain.get_limit_orders(@base, @quote, limit)
    end

    def trade_history(since=nil,to=nil,limit=100)
      since ||= Date.new(1970,1,1)
      to ||= Date.today
      @blockchain.get_trade_history(@base, @quote,
          since.strftime(DATE_FORMAT),
          to.strftime(DATE_FORMAT), limit)
    end

    def get_24_volume
      @blockchain.get_24_volume(@base, @quote)
    end

    def settlement_price
      @base.settlement_price / @quote.settlement_price
    end

    # @TODO GRAPHENE PORT
    # THEESE METHODS NEED PORTING:
    # - blockchain_market_list_shorts
    # - last_fill
    # - blockchain_market_get_asset_collateral
    # - order.price

    private

    def valid!
      raise Err, 'Invalid market; quote ID <= base ID' if @quote.id <= @base.id
    end

  end
end
