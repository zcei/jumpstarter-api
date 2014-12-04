require "jumpstarter/api/version"
require "jumpstarter/auth"
require 'json'

module Jumpstarter
  module Api
    class JumpstarterEnv
      attr_accessor :env
      # Creates new environment based on env /app/env.json
      def initialize(env = false)
        if env
          @env = env
        else
          filename = '/app/env.json'
          raise IOError, 'No env given & env.json not found!' unless File.file?(filename)
          file = File.read(filename)
          @env = JSON.parse(file)
        end
      end

      # Environment getter

      def ident
        self.env['ident']
      end

      def user
        self.env['ident']['user']
      end

      def container
        self.env['ident']['container']
      end

      def app
        self.env['ident']['app']
      end

      def core_settings
        self.env['settings']['core']
      end

      def app_settings
        self.env['settings']['app']
      end

      # Find by dot-notation: e.g. ident.user.email
      def find(path)
        keys = path.split('.')

        if keys.length == 0
          return nil
        end

        obj = self.env
        for i in 0...keys.size do
          if obj.key?(keys[i])
            obj = obj[keys[i]]
          else
            return nil
          end
        end

        obj
      end

      def validate_session(token)
        Jumpstarter::Api::Auth::validate_session(self, token)
      end
    end
  end
end
