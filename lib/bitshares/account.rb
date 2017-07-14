module Bitshares

  class Account

    attr_reader :wallet, :name

    include RPC

    def initialize(wallet, name)
      @wallet = wallet
      @name = name
    end

    def default_args
      [name]
    end

    def method_prefix
      'wallet_account_'
    end

  end

end
