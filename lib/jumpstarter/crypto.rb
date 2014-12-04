require 'digest/sha2'

module Jumpstarter
  module Crypto

  def validate_session(env, token)
    session_key = env.container[:session_key]
    parsed_token = self.parse_token(token)

    raise ArgumentError, 'Invalid Auth Token' unless parse_token && session_key

    self.verify_token(parse_token, session_key)
  end

  private

    def hex_str_to_byte_array(str)
      # Match two chars (e.g. 08, AF, 63, ..)
      # and get each hex value
      str.scan(/../).map(&:hex)
    end

    def ntohl(str)
      str.unpack('C*').reverse.pack('C*')
    end

    def parse_token(token)
      hex_constraint = /\A[0-9a-fA-F]+\Z/

      if token.size != 144 || hex_constraint.match(token).nil?
        raise ArgumentError, 'Invalid Auth Token'
      end

      {
        e_time: token[0, 16],      # first 16 chars
        y:     token[16, 64],     # next 64 chars
        h:     token[16 + 64..-1] # last chars 'til the end
      }
    end

    def verify_token(parsed_token, session_key)
      # Integer representation of expiry date
      token_expiry = ntohl(parsed_token[:e_time][8..-1]).hex
      if token_expiry * 1000 < Time.now.to_i
        return false
      end

      shasum = Digest::SHA2.new <<
        hex_str_to_byte_array(parsed_token[:e_time]).pack('C*') <<
        hex_str_to_byte_array(parsed_token[:y]).pack('C*') <<
        hex_str_to_byte_array(session_key).pack('C*')

      shasum.to_s == parse_token[:h]
    end

  end
end
