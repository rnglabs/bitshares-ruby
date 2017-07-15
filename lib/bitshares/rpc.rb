module Bitshares

  module RPC
    class Err < RuntimeError; end

    private

    # Safe default, override on extension
    def method_prefix
      ''
    end

    def default_args
      []
    end

    def wallet_methods
      []
    end

    def method_missing(m, *args)
      require_wallet_api! if wallet_methods.include?(m)
      CLIENT.request("#{method_prefix}#{m}", default_args + args)
    end

    def require_wallet_api!
      raise Err, "Need access to a Wallet API!" unless CLIENT.wallet_api_enabled?
    end
  end

end
