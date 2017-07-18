module Bitshares
  module RPCMagic

    def method_missing(m, *args)
      @rpc.request(m, args)
    end
  end
end
