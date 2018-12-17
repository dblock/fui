require 'spec_helper'

describe Fui do
  context 'find' do
    before :each do
      @binary = File.expand_path(File.join(__FILE__, '../../../bin/fui'))
      @fixtures = File.expand_path(File.join(__FILE__, '../../fixtures/m'))
    end
    describe '#help' do
      it 'displays help' do
        help = `"#{@binary}" help`
        expect(help).to include 'fui - Find unused imports in an Objective-C codebase'
      end
    end
    describe '#find' do
      it 'is the default action' do
        files = `"#{@binary}" --path "#{@fixtures}"`
        expect(files.split("\n")).to eq ['unused_class.h']
      end
      it 'finds all unreferences headers' do
        files = `"#{@binary}" --path "#{@fixtures}" find`
        expect(files.split("\n")).to eq ['unused_class.h']
      end
      it 'defaults to the current directory' do
        files = `"#{@binary}"`
        expect(files.split("\n")).to include 'spec/fixtures/h/header.h'
      end
      it 'defaults to the current directory and returns unreferenced headers relative to it' do
        files = `cd #{@fixtures} ; "#{@binary}"`
        expect(files.split("\n")).to eq ['unused_class.h']
      end
      it 'returns a non-zero error code when files are found' do
        `cd #{@fixtures} ; "#{@binary}"`
        expect($CHILD_STATUS.exitstatus).to eq 1
      end
      it 'returns a zero error code when no files are found' do
        _files = `cd #{File.expand_path(File.join(__FILE__, '../../../bin/'))} ; "#{@binary}"`
        expect($CHILD_STATUS.exitstatus).to eq 0
      end
    end
    describe '#verbose' do
      it 'displays verbose output' do
        output = `"#{@binary}" --verbose --path "#{@fixtures}" find`
        output = output.split("\n")
        expect(output).to include 'Checking used_class.h ...'
        expect(output).to include 'Found unused_class.h'
      end
    end
    describe '#delete' do
      it "doesn't delete files by default" do
        output = `"#{@binary}" --verbose --path "#{@fixtures}" delete --no-prompt`
        output = output.split("\r\n")
        expect(output).to include 'Removing unused_class.m (simulation)'
        expect(File.exist?(File.join(@fixtures, 'unused_class.m'))).to be true
      end
      it 'deletes files with --perform' do
        Dir.mktmpdir do |tmpdir|
          FileUtils.cp_r @fixtures.to_s, tmpdir
          output = `"#{@binary}" --verbose --path "#{tmpdir}" delete --no-prompt --perform`
          output = output.split("\r\n")
          expect(output).to include 'Removing m/unused_class.m'
          expect(File.exist?(File.join(tmpdir, 'm/unused_class.m'))).to be false
        end
      end
      pending 'prompts for deletion'
    end
  end
end
