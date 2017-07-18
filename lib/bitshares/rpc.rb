module Bitshares
  class RPC
    class Err < RuntimeError; end

    def check_rpc!
      return true if rpc_online?
      raise Err, 'RPC Server is offline!'
    end

    def initialize(config)
      @uri = URI(config[:server])
      @rpc = Net::HTTP::Post.new(@uri)
      @rpc.content_type = 'application/json'
      user, pass = config.values_at(:username,:password)
      @rpc.basic_auth(user, pass) if user
    end

    def request(m, args = [])
      response = nil
      # id should be random/sequential, user to id request/answer
      @rpc.body = { method: m, params: args, jsonrpc: '2.0', id: 0 }.to_json
      Net::HTTP.start(@uri.hostname, @uri.port, :use_ssl => use_ssl) do |http|
        response = http.request(@rpc)
      end
      check_credentials! response
      result = JSON.parse response.body
      check_errors! result
      return result['result']
    end

    private

    def rpc_online?
      @online ||= !(request('get_chain_id') =~ /[0-9a-f]{64}/).nil?
    end

    def check_credentials!(response)
      raise Err, 'Bad credentials' if response.class == Net::HTTPUnauthorized
    end

    def check_errors!(result)
      e = result['error'] || return
      if e['message']
        raise Err, e['message']
      else
        raise Err, JSON.pretty_generate(e)
      end
    end

    def use_ssl
      @uri.scheme.downcase == 'https'
    end

  end

end
