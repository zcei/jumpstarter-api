require "jumpstarter/api/version"
require "jumpstarter/crypto"
require 'json'

module Jumpstarter
  module Api
    attr_reader :env
    # Creates new environment based on env /app/env.json
    def initialize
      filename = ENV['RUBY_ENV'] == 'test' ? '../../spec/test_env.json' : '/app/env.json'

      raise IOError, 'env.json not found!' unless File.file?(filename)

      file = File.read(filename)
      @env = JSON.parse(file)
    end

    def ident
      self.env.ident
    end

    def user
      self.env.ident.user
    end

    def container
      self.env.ident.container
    end

    def app
      self.env.ident.app
    end

    def core_settings
      self.env.settings.core
    end

    def app_settings
      self.env.settings.app
    end

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
      # TODO: validate user
      # TODO: build crypto functions from node.js implemenation
      true
    end
  end
end
