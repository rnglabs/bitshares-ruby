module Bitshares

  class Client

    include RPC

    def init
      @uri = nil
      @req = Net::HTTP::Post.new(uri)
      @req.content_type = 'application/json'
      user, pass = Bitshares.config.values_at(:rpc_username,:rpc_password)
      @req.basic_auth(user, pass) if user
      check_rpc!
      return self
    end

    def uri
      @uri ||= URI(Bitshares.config[:rpc_server])
    end

    def use_ssl
      uri.scheme.downcase == 'https'
    end

    def request(m, args = [])
      response = nil
      # id should be random/sequential, user to id request/answer
      @req.body = { method: m, params: args, jsonrpc: '2.0', id: 0 }.to_json
      Net::HTTP.start(uri.hostname, uri.port, :use_ssl => use_ssl) do |http|
        response = http.request(@req)
      end
      check_credentials! response
      result = JSON.parse response.body
      check_errors! result
      return result['result']
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

    private

    def check_rpc!
      return true if rpc_online?
      raise Err, 'RPC Server is offline!'
    end

    def rpc_online?
      !(get_chain_id =~ /[0-9a-f]{64}/).nil?
    end
  end

end
