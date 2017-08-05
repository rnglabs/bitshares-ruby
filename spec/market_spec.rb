require 'spec_helper'

describe Bitshares::Market do
  let!(:client) { Bitshares.testnet }
  let!(:valid_asset_1) { 'TEST' }
  let!(:valid_asset_2) { 'CNY' }
  let(:market) { client.market(valid_asset_1,valid_asset_2) }
  let(:invalid_market) { client.market(valid_asset_2,valid_asset_1) }

  MULTIPLIER = 10 # for this asset pair

  context '#new(quote, base)' do
    it 'raises Bitshares::Asset::Err "Invalid asset" if an invalid asset symbol is used' do
      expect(->{client.market(valid_asset_1, 'GARBAGE')}).to raise_error Bitshares::Asset::Err
    end

    it 'raises Bitshares::Market::Err "Invalid market; quote ID <= base ID" if it is' do
      expect(->{invalid_market}).to raise_error Bitshares::Market::Err, 'Invalid market; quote ID <= base ID'
    end

    it 'instantiates an instance of the class with valid asset symbols (case insensitive)' do
      expect(client.market(valid_asset_1.downcase, valid_asset_2.downcase).class).to eq Bitshares::Market
    end
  end

  context '#quote' do
    it 'returns the quote asset symbol' do
      expect(market.quote.symbol).to eq valid_asset_2
    end
  end

  context '#base' do
    it 'returns the base asset symbol' do
      expect(market.base.symbol).to eq valid_asset_1
    end
  end

  context '#lowest_ask' do
    it 'returns lowest ask price from the ticker' do
      allow(market).to receive(:ticker).and_return({'lowest_ask' => 100})
      expect(market.lowest_ask).to eq 100
    end
  end

  context '#highest_bid' do
    it 'returns highest bid price from the ticker' do
      allow(market).to receive(:ticker).and_return({'highest_bid' => 100})
      expect(market.highest_bid).to eq 100
    end
  end

  context '#mid_price' do
    it 'returns the mid price' do
      allow(market).to receive(:ticker).and_return({'lowest_ask' => 100, 'highest_bid' => 120})
      mid = market.mid_price
      expect(mid).to eq 110
    end
  end

end
