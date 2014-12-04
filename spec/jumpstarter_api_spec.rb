require 'spec_helper'

describe Jumpstarter::Api do
  before do
    filename = File.expand_path("./fixtures/env.json", File.dirname(__FILE__))
    file = File.read(filename)
    @env = JSON.parse(file)

    @jumpstarter = Jumpstarter::Api::JumpstarterEnv.new(@env)
  end

  describe '#find with accessible key' do
    let(:input) { 'ident.user.email' }
    let(:output) { @jumpstarter.find(input) }

    it 'should return jenny@example.org' do
      expect(output).to eq 'jenny@example.org'
    end
  end

  describe '#find with non-accessible key' do
    let(:input) { 'ident.user.foo' }
    let(:output) { @jumpstarter.find(input) }

    it 'should return nil' do
      expect(output).to eq nil
    end
  end

  describe 'env methods' do

    describe '#ident' do
      it 'should return ident hash' do
        expect(@jumpstarter.ident).to eq @env['ident']
      end
    end

    describe '#user' do
      it 'should return user hash' do
        expect(@jumpstarter.user).to eq @env['ident']['user']
      end
    end

    describe '#container' do
      it 'should return container hash' do
        expect(@jumpstarter.container).to eq @env['ident']['container']
      end
    end

    describe '#app' do
      it 'should return app hash' do
        expect(@jumpstarter.app).to eq @env['ident']['app']
      end
    end

    describe '#core_settings' do
      it 'should return core_settings hash' do
        expect(@jumpstarter.core_settings).to eq @env['settings']['core']
      end
    end

    describe '#app_settings' do
      it 'should return app_settings hash' do
        expect(@jumpstarter.app_settings).to eq @env['settings']['app']
      end
    end
  end

  describe 'auth' do
    it 'should validate' do
      # Get your own token and be fast running the test :)
      # https://github.com/jumpstarter-io/help/wiki/Testing-Portal-Auth-Implementations
      token = ''
      expect(@jumpstarter.validate_session(token)).to eq true
    end
  end
end
