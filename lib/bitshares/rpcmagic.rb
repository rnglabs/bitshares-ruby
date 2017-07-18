module Bitshares
  module RPCMagic
    class Err < RuntimeError; end

    def method_missing(m, *args)
      @rpc.request(m, args)
    end
  end
end
