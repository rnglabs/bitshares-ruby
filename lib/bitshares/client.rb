module Bitshares

  class Client

    class Err < RuntimeError; end

    include RPC

    def init
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
      resp = nil
      @req.body = { method: m, params: args, jsonrpc: '2.0', id: 0 }.to_json # id is API number?
      Net::HTTP.start(uri.hostname, uri.port, :use_ssl => use_ssl) do |http|
        resp = http.request(@req)
      end
      # @TODO improve error detection
      raise Err, 'Bad credentials' if resp.class == Net::HTTPUnauthorized
      result = JSON.parse(resp.body)
      e = result['error']
      raise Err, JSON.pretty_generate(e), "#{m} #{args.join(' ') if args}" if e
      return result['result']
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
