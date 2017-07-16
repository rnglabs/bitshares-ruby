module Bitshares

  class Account

    attr_reader :wallet, :name

    include RPC

    def initialize(wallet, name)
      @wallet = wallet
      @name = name
    end

  end

end
