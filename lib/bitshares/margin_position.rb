module Bitshares

  class MarginPosition
    attr_reader :base, :quote

    def initialize(blockchain, position)
      @blockchain = blockchain
      @position = position
      @base, @quote = Bitshares::Asset.get_many_by_ids(@blockchain, [base_id, quote_id])
    end

    def method_missing(m, *args)
      @position[m.to_s]
    end

    def base_id
      @position['call_price']['base']['asset_id']
    end

    def quote_id
      @position['call_price']['quote']['asset_id']
    end

    def collateral
      @position['collateral'].to_f / 10**base.precision
    end

    def debt
      @position['debt'].to_f / 10**quote.precision
    end

    def call_price
      collateral / (debt * 1.75)
    end

    def collateral_ratio
      collateral * quote.settlement_price / debt
    end
  end

end
