require 'digest/sha2'

module Jumpstarter
  module Api
    class Auth

      def self.validate_session(env, token)
        session_key = env.container['session_key']
        parsed_token = self.parse_token(token)

        raise ArgumentError, 'Invalid Auth Token' unless parsed_token && session_key

        self.verify_token(parsed_token, session_key)
      end

      def self.hex_str_to_byte_array(str)
        # Match two chars (e.g. 08, AF, 63, ..)
        # and get each hex value
        str.scan(/../).map(&:hex)
      end

      def self.ntohl(str)
        str.unpack('H*').reverse.pack('H*')
      end

      def self.parse_token(token)
        hex_constraint = /\A[0-9a-fA-F]+\Z/

        # Be sure the token is from proper format - only hex values allowed (0-9 & a-f)
        if token.size != 144 || hex_constraint.match(token).nil?
          raise ArgumentError, 'Invalid Auth Token'
        end

        {
          e_time: token[0, 16],      # first 16 chars
          y:      token[16, 64],     # next 64 chars
          h:      token[16 + 64..-1] # last chars 'til the end
        }
      end

      def self.verify_token(parsed_token, session_key)
        # Integer representation of expiry date
        token_expiry = ntohl(parsed_token[:e_time][8..-1]).hex

        # Token expires in ~20 seconds
        if token_expiry < Time.now.to_i
          return false
        end

        # Create digest to sign token
        shasum = Digest::SHA2.new <<
          hex_str_to_byte_array(parsed_token[:e_time]).pack('C*') <<
          hex_str_to_byte_array(parsed_token[:y]).pack('C*') <<
          hex_str_to_byte_array(session_key).pack('C*')

        shasum.to_s == parsed_token[:h]
      end
    end
  end
end
