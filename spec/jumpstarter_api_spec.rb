require 'spec_helper'

describe Jumpstarter::Api do
  subject { Jumpstarter::Api.new }

  describe '#find with accessible key' do
    let(:input) { 'ident.user.email' }
    let(:output) { subject.find(input) }

    it 'should return jenny@example.org' do
      expect(output.downcase).to eq 'jenny@example.org'
    end
  end

  describe '#find with non-accessible key' do
    let(:input) { 'ident.user.foo' }
    let(:output) { subject.find(input) }

    it 'should return nil' do
      expect(output.downcase).to eq nil
    end
  end

  describe 'env methods' do
    let(:api) { subject }

    it 'should return jenny@example.org' do
      expect(api.mail).to eq 'jenny@example.org'
    end
  end
end
