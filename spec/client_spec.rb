require 'spec_helper'

describe Bitshares::Client do

  let(:client) { CLIENT }

  context '#new' do
    it 'raises Bitshares::Client::Rpc::Err "RPC Server is offline!" if the server isn\'t running' do
      client.init
      allow(client).to receive(:rpc_online?).and_return false
      expect(->{client.send :check_rpc!}).to raise_error Bitshares::Client::Err, 'RPC Server is offline!'
    end
  end


  context '#rpc_request' do
    # context 'using ENV credentials' do
      # it 'with invalid username raises Bitshares::Client::Err "Bad credentials"' do
      #   stub_const('ENV', ENV.to_hash.merge('BITSHARES_ACCOUNT' => 'wrong_username', 'BITSHARES_PASSWORD' => 'password1'))
      #   client.init
      #   expect(->{client.get_chain_id}).to raise_error Bitshares::Client::Err, 'Bad credentials'
      # end

      # it 'with invalid password raises Bitshares::Client::Err "Bad credentials"' do
      #   stub_const('ENV', ENV.to_hash.merge('BITSHARES_ACCOUNT' => 'test1', 'BITSHARES_PASSWORD' => 'wrong_password'))
      #   client.init
      #   expect(->{client.get_chain_id}).to raise_error Bitshares::Client::Err, 'Bad credentials'
      # end

      it 'with an invalid client command raises Bitshares::Client::Err' do
        client.init
        expect(->{client.not_a_cmd}).to raise_error Bitshares::Client::Err
      end

      it 'with a valid client command returns valid data' do
        client.init
        expect(client.get_chain_id).to match /[0-9a-f]{64}/
      end
    end

  #   context 'using config credentials' do

  #     it 'with invalid username raises Bitshares::Client::Err "Bad credentials"' do
  #       Bitshares.configure(:rpc_username => 'wrong_username')
  #       stub_const('ENV', ENV.to_hash.merge('BITSHARES_ACCOUNT' => nil))
  #       stub_const('ENV', ENV.to_hash.merge('BITSHARES_PASSWORD' => nil))
  #       client.init
  #       expect(->{client.get_info}).to raise_error Bitshares::Client::Err, 'Bad credentials'
  #     end

  #     it 'with invalid password raises Bitshares::Client::Err "Bad credentials"' do
  #       Bitshares.configure(:rpc_password => 'wrong_password')
  #       stub_const('ENV', ENV.to_hash.merge('BITSHARES_ACCOUNT' => nil))
  #       stub_const('ENV', ENV.to_hash.merge('BITSHARES_PASSWORD' => nil))
  #       client.init
  #       expect(->{client.get_info}).to raise_error Bitshares::Client::Err, 'Bad credentials'
  #     end

  #     it 'with valid credentials and invalid client command raises Bitshares::Client::Err' do
  #       stub_const('ENV', ENV.to_hash.merge('BITSHARES_ACCOUNT' => nil))
  #       stub_const('ENV', ENV.to_hash.merge('BITSHARES_PASSWORD' => nil))
  #       client.init
  #       expect(->{client.not_a_cmd}).to raise_error Bitshares::Client::Err
  #     end

  #     it 'with valid credentials and valid client command returns a Hash of returned JSON data' do
  #       stub_const('ENV', ENV.to_hash.merge('BITSHARES_ACCOUNT' => nil))
  #       stub_const('ENV', ENV.to_hash.merge('BITSHARES_PASSWORD' => nil))
  #       client.init
  #       expect(client.get_info.class).to eq Hash
  #     end

  #   end
  # end

end
