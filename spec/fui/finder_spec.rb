require 'spec_helper'

describe Fui::Finder do
  context 'included from a .m file' do
    before :each do
      @fixtures_dir = File.expand_path(File.join(__FILE__, '../../fixtures/m'))
    end
    describe '#find' do
      it 'finds all files for which the block yields true' do
        files = Fui::Finder.send(:find, @fixtures_dir) do |file|
          File.extname(file) == '.h'
        end
        expect(files.sort).to eq Dir["#{@fixtures_dir}/*.h"].sort
      end
    end
    describe '#headers' do
      it 'finds all headers' do
        finder = Fui::Finder.new(@fixtures_dir)
        expect(finder.headers.map(&:filename).sort).to eq(['unused_class.h', 'used_class.h'])
      end
    end
    describe '#references' do
      it 'maps references' do
        finder = Fui::Finder.new(@fixtures_dir)
        expect(finder.references.size).to eq(2)
        expect(Hash[finder.references.map { |k, v| [k.filename, v.count] }]).to eq('unused_class.h' => 0,
                                                                                   'used_class.h' => 1)
      end
    end
    describe '#unsed_references' do
      it 'finds unused references' do
        finder = Fui::Finder.new(@fixtures_dir)
        expect(Hash[finder.unused_references.map { |k, v| [k.filename, v.count] }]).to eq('unused_class.h' => 0)
      end
    end
  end
  context 'included from a .mm file' do
    before :each do
      @fixtures_dir = File.expand_path(File.join(__FILE__, '../../fixtures/mm'))
    end
    describe '#find' do
      it 'finds all files for which the block yields true' do
        files = Fui::Finder.send(:find, @fixtures_dir) do |file|
          File.extname(file) == '.h'
        end
        expect(files.sort).to eq Dir["#{@fixtures_dir}/*.h"].sort
      end
    end
    describe '#headers' do
      it 'finds all headers' do
        finder = Fui::Finder.new(@fixtures_dir)
        expect(finder.headers.map(&:filename).sort).to eq(['unused_class.h', 'used_class.h'])
      end
    end
    describe '#references' do
      it 'maps references' do
        finder = Fui::Finder.new(@fixtures_dir)
        expect(finder.references.size).to eq(2)
        expect(Hash[finder.references.map { |k, v| [k.filename, v.count] }]).to eq('unused_class.h' => 0,
                                                                                   'used_class.h' => 1)
      end
    end
    describe '#unsed_references' do
      it 'finds unused references' do
        finder = Fui::Finder.new(@fixtures_dir)
        expect(Hash[finder.unused_references.map { |k, v| [k.filename, v.count] }]).to eq('unused_class.h' => 0)
      end
    end
  end
  context 'included from a .pch file' do
    before :each do
      @fixtures_dir = File.expand_path(File.join(__FILE__, '../../fixtures/pch'))
    end
    describe '#unsed_references' do
      it 'finds unused references' do
        finder = Fui::Finder.new(@fixtures_dir)
        expect(Hash[finder.unused_references.map { |k, v| [k.filename, v.count] }]).to eq('unused_class.h' => 0)
      end
    end
  end
  context 'included from a .h file' do
    before :each do
      @fixtures_dir = File.expand_path(File.join(__FILE__, '../../fixtures/h'))
    end
    describe '#unsed_references' do
      it 'finds unused references' do
        finder = Fui::Finder.new(@fixtures_dir)
        expect(Hash[finder.unused_references.map { |k, v| [k.filename, v.count] }]).to eq('header.h' => 0,
                                                                                          'unused_class.h' => 0)
      end
    end
  end
  context 'custom UIView subclasses' do
    before :each do
      @fixtures_dir = File.expand_path(File.join(__FILE__, '../../fixtures/nib'))
    end
    describe '#unsed_references' do
      it 'finds no unused references' do
        finder = Fui::Finder.new(@fixtures_dir)
        expect(finder.unused_references.count).to eq(0)
      end
    end
  end
  context 'ignorexib option set to false' do
    before :each do
      @fixtures_dir = File.expand_path(File.join(__FILE__, '../../fixtures/nibself'))
    end
    describe '#unsed_references' do
      it 'finds no unused references' do
        finder = Fui::Finder.new(@fixtures_dir)
        expect(finder.unused_references.count).to eq(0)
      end
    end
  end
  context 'ignorexib option set to true' do
    before :each do
      @fixtures_dir = File.expand_path(File.join(__FILE__, '../../fixtures/nibself'))
    end
    describe '#unsed_references' do
      it 'finds one unused references' do
        finder = Fui::Finder.new(@fixtures_dir, 'ignorexib' => true)
        expect(finder.unused_references.count).to eq(1)
      end
    end
  end
  context 'global option set to true' do
    before :each do
      @fixtures_dir = File.expand_path(File.join(__FILE__, '../../fixtures/global_import'))
    end
    describe '#unused_references' do
      it 'finds one unused global reference' do
        finder = Fui::Finder.new(@fixtures_dir, 'global' => true)
        expect(Hash[finder.unused_references.map { |k, v| [k.filename, v.count] }]).to eq("header.h" => 0, "unused_class.h" => 0)
      end
    end
  end
  context 'global option set to false' do
    before :each do
      @fixtures_dir = File.expand_path(File.join(__FILE__, '../../fixtures/global_import'))
    end
    describe '#unused_references' do
      it 'finds no unused global references' do
        finder = Fui::Finder.new(@fixtures_dir, 'global' => false)
        expect(Hash[finder.unused_references.map { |k, v| [k.filename, v.count] }]).to eq("header.h" => 0, "unused_class.h" => 0, "used_class.h" => 0)
      end
    end
  end
end
