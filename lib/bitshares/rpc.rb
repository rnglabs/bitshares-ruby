module Bitshares

  module RPC
    private
    # Safe default, override on extension
    def method_prefix
      ''
    end

    # Safe default, override on extension
    def default_args
      []
    end

    def method_missing(m, *args)
      CLIENT.request("#{method_prefix}#{m}", default_args + args)
    end

  end

end
