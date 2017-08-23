module Bitshares

  class Account
    class Err < RuntimeError; end

    def initialize(blockchain, name)
      @blockchain = blockchain
      @account = @blockchain.lookup_account_names([name]).first
    end

    def method_missing(m, *args)
      @account[m.to_s]
    end

    def valid?
      !@account.nil?
    end

    def get_workers
      @blockchain.get_workers_by_account(id)
    end

    def get_witness
      @blockchain.get_witness_by_account(id)
    end

    def get_vesting_balances
      @blockchain.get_vesting_balances(id)
    end

    def get_proposed_transactions
      @blockchain.get_proposed_transactions(id)
    end

    # collateral / (debt * 1.75) = call_price
    def get_margin_positions
      @blockchain.get_margin_positions(id).collect do |mp|
        Bitshares::MarginPosition.new(@blockchain, mp)
      end
    end

    def get_committee_member
      @blockchain.get_committee_member_by_account(id)
    end

    def references
      @blockchain.get_account_references(id)
    end

    def balances(*assets)
      assets = Bitshares::Helpers.to_array(assets)
      assets = @blockchain.assets(*assets).collect{|a| a['id'] unless a.nil? } unless assets.empty?
      @blockchain.get_account_balances(id, assets)
    end
  end
end
