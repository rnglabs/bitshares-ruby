module Bitshares

  class Wallet

    attr_reader :name, :account

    include RPC

    def initialize(name)
      @name = name
      @account = nil
      @password = Bitshares.config[:wallet][@name]
    end

    def account(name)
      @account = Bitshares::Account.new(self, name)
    end

    # Methods that use the wallet should make sure it's open
    # So a check there should sufice
    def require_wallet_api!
      raise Err, "Need access to a Wallet API!" unless CLIENT.wallet_api_enabled?
    end

    def open
      require_wallet_api!
      wallet_open @name
    end

    def lock
      open # must be opened first
      wallet_lock
    end

    def unlock(timeout = 1776)
      open # must be opened first
      wallet_unlock timeout, @password
    end

    def open?
      get_info['open']
    end

    def closed?
      !open?
    end

    def unlocked?
      open
      get_info['unlocked']
    end

    def locked?
      !unlocked?
    end

  end

end
