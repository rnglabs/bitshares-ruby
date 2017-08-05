require 'spec_helper'

describe Bitshares::Market do
  let!(:client) { Bitshares.testnet }
  let!(:valid_asset_1) { 'EUR' }
  let(:bts) { Bitshares::Asset.new(client, 'TEST') }
  let(:asset) { Bitshares::Asset.new(client, valid_asset_1) }

  context '#new(blockchain, name)' do
    it 'raises Bitshares::Asset::Err "Invalid asset" if an invalid asset symbol is used' do
      expect(->{Bitshares::Asset.new(client, 'GARBAGE')}).to raise_error Bitshares::Asset::Err
    end

    it 'instantiates an instance of the class with valid asset symbols (case insensitive)' do
      expect(Bitshares::Asset.new(client, valid_asset_1.downcase).class).to eq Bitshares::Asset
    end
  end

  context 'data fields as methods' do
    it 'returns the asset symbol' do
      expect(asset.symbol).to eq valid_asset_1
    end

    it 'returns the asset id' do
      expect(bts.id).to eq '1.3.0'
    end
  end

end
