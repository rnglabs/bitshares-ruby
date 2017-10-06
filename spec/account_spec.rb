require 'spec_helper'

describe Bitshares::Account do
  let!(:client) { Bitshares.testnet }
  let!(:valid_account_1) { 'witness-account' }
  let(:subject) { Bitshares::Account.new(client, valid_account_1) }

  context '#new(blockchain, name)' do
    it 'it gives an invalid account object if its not an account' do
      expect(Bitshares::Account.new(client, 'please-never-create-me')).to_not be_valid
    end

    it 'gives a valid instance of an account' do
      expect(subject).to be_valid
    end

    it 'gets the correct account' do
      expect(subject.id).to eq "1.2.1"
    end

    it 'gets it full' do
      full = subject.get_full
      expect(full).to_not be_nil
      expect(full['account']).to_not be_nil
      expect(full['account']['name']).to eq subject.name
    end
  end

end
