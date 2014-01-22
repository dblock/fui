require 'spec_helper'

describe Fui::Header do
  describe "#header?" do
    it "correctly matches .h files" do
      Fui::Header.header?("foo.h").should be_true
    end
    it "correctly matches .rb files" do
      Fui::Header.header?("foo.rb").should be_false
    end
  end
  describe "#initialize" do
    it "creates an instance of header" do
      instance = Fui::Header.new(__FILE__)
      instance.path.should == __FILE__
      instance.filename.should == "header_spec.rb"
      instance.filename_without_extension.should == "header_spec"
    end
  end
end
