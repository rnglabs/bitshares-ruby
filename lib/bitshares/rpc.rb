module Bitshares

  module RPC
    class Err < RuntimeError; end

    private

    def method_missing(m, *args)
      CLIENT.request(m, args)
    end

  end

end
