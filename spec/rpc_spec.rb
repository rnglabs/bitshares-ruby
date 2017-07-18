require 'spec_helper'

describe Bitshares::Client do
  let(:rpc) {
    Bitshares.testnet
    Bitshares::RPC.new(Bitshares.config[:rpc])
  }

  context '#check_rpc!' do
    it 'raises Bitshares::Client::Rpc::Err "RPC Server is offline!" if the server isn\'t running' do
      allow(rpc).to receive(:rpc_online?).and_return false
      expect(->{rpc.send :check_rpc!}).to raise_error Bitshares::RPC::Err, 'RPC Server is offline!'
    end
  end


  context '#rpc_request' do
    # context 'using ENV credentials' do
      # it 'with invalid username raises Bitshares::Client::Err "Bad credentials"' do
      #   stub_const('ENV', ENV.to_hash.merge('BITSHARES_ACCOUNT' => 'wrong_username', 'BITSHARES_PASSWORD' => 'password1'))
      #   expect(->{client.get_chain_id}).to raise_error Bitshares::Client::Err, 'Bad credentials'
      # end

      # it 'with invalid password raises Bitshares::Client::Err "Bad credentials"' do
      #   stub_const('ENV', ENV.to_hash.merge('BITSHARES_ACCOUNT' => 'test1', 'BITSHARES_PASSWORD' => 'wrong_password'))
      #   expect(->{client.get_chain_id}).to raise_error Bitshares::Client::Err, 'Bad credentials'
      # end

      it 'with an invalid client command raises Bitshares::RPC::Err' do
        expect(-> { rpc.send(:request,'not_a_cmd') } ).to raise_error Bitshares::RPC::Err
      end

      it 'with a valid client command returns valid data' do
        expect(rpc.send(:request,'get_chain_id')).to match /[0-9a-f]{64}/
      end
    end

end
