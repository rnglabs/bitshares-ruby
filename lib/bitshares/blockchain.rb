module Bitshares

  class Blockchain
    include RPC

    def self.method_prefix
      'blockchain_'
    end

  end

end
