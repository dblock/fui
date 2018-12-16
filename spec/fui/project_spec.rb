require 'spec_helper'

describe Fui::Project do
  describe '#project?' do
    it 'correctly matches .pbxproj files' do
      expect(Fui::Project.project?('project.pbxproj')).to be true
    end
    it 'correctly matches .rb files' do
      expect(Fui::Project.project?('foo.rb')).to be false
    end
  end
  describe '#initialize' do
    it 'creates an instance of project' do
      instance = Fui::Project.new(__FILE__)
      expect(instance.path).to eq(__FILE__)
      expect(instance.filename).to eq('project_spec.rb')
    end
  end
  describe '#bridging_headers' do
    before :each do
      @fixture = File.expand_path(File.join(__FILE__, '../../fixtures/bridging_headers/BridgingHeaderSpec/BridgingHeaderSpec.xcodeproj/project.pbxproj'))
    end
    it 'bridging headers are found' do
      project = Fui::Project.new(@fixture)
      expect(project.bridging_headers(false)).to eq(['BridgingHeaderSpec-Bridging-Header.h'])
    end
  end
  describe '#bridging_headers' do
    before :each do
      @fixture = File.expand_path(File.join(__FILE__))
    end
    it 'bridging headers are not found' do
      project = Fui::Project.new(@fixture)
      expect(project.bridging_headers(false)).to eq([])
    end
  end
end
