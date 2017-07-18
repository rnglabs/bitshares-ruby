module Bitshares

  class Wallet
    class Err < RuntimeError; end

    attr_reader :name, :account

    include RPCMagic

    def initialize(rpc, config)
      @rpc = rpc
      @name = config[:name]
      @password = config[:password]
    end

    def require_wallet_api!
      raise Err, "Need access to a Wallet API!" unless wallet_api_enabled?
    end

    def self.wallet_api_enabled?
      [@name,@password,@rpc].none?(&:nil?)
    end

    def locked?
      is_locked
    end

  end

end
