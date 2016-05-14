require 'spec_helper'

describe Fui::Header do
  describe '#header?' do
    it 'correctly matches .h files' do
      expect(Fui::Header.header?('foo.h')).to be true
    end
    it 'correctly matches .rb files' do
      expect(Fui::Header.header?('foo.rb')).to be false
    end
  end
  describe '#initialize' do
    it 'creates an instance of header' do
      instance = Fui::Header.new(__FILE__)
      expect(instance.path).to eq(__FILE__)
      expect(instance.filename).to eq('header_spec.rb')
      expect(instance.filename_without_extension).to eq('header_spec')
    end
  end
end
