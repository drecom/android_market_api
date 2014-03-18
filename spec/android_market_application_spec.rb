# -*- coding: utf-8 -*-
require 'spec_helper'

describe AndroidMarketApplication do
  shared_examples_for :not_null_properties do
    its(:name)            { should     be_an_instance_of String }
    its(:name)            { should_not be_empty }
    its(:developer_name)  { should     be_an_instance_of String }
    its(:developer_name)  { should_not be_empty }
    its(:current_version) { should     be_an_instance_of String }
    its(:current_version) { should_not be_empty }
    its(:price)           { should_not be_empty }
    its(:price)           { should     be_an_instance_of String }
    its(:rating_value)    { should_not be_empty }
    its(:rating_value)    { should     be_an_instance_of String }
    its(:rating_count)    { should_not be_empty }
    its(:rating_count)    { should     be_an_instance_of String }
    its(:updated)         { should_not be_empty }
    its(:updated)         { should     be_an_instance_of String }
    its(:sdk_required)    { should_not be_empty }
    its(:sdk_required)    { should     be_an_instance_of String }
    its(:category)        { should_not be_empty }
    its(:category)        { should     be_an_instance_of String }
    its(:category_id)     { should_not be_empty }
    its(:category_id)     { should     be_an_instance_of String }
    its(:downloads)       { should_not be_empty }
    its(:downloads)       { should     be_an_instance_of String }
    its(:size)            { should_not be_empty }
    its(:size)            { should     be_an_instance_of String }
    its(:content_rating)  { should_not be_empty }
    its(:content_rating)  { should     be_an_instance_of String }
    its(:description)     { should_not be_empty }
    its(:description)     { should     be_an_instance_of String }
    its(:screenshots)     { should_not be_empty }
    its(:screenshots)     { should     be_an_instance_of Array }
    its(:icon)            { should_not be_empty }
    its(:icon)            { should     be_an_instance_of String }
    its(:update_text)     { should_not be_empty }
    its(:update_text)     { should     be_an_instance_of String }
  end

  shared_examples_for :android_market_application_base_examples do
    before(:all) do
      AndroidMarketApplication.debug = false
    end

    describe "#initialize" do
      subject{ @app }

      before(:all) do
        # call API once. because API call is very heavy!
        # wget https://play.google.com/store/apps/details?id=com.twitter.android&hl=en
        @app = AndroidMarketApplication.new("com.twitter.android", :language => "en")
      end

      let(:package)  { "com.twitter.android" }
      let(:options) do
        {
            :language => "en",
            :proxy => nil,
            :header => {
                "User-Agent" => "ruby",
            }
        }
      end

      its(:package)         { should == package }
      its(:language)        { should == options[:language] }
      its(:name)            { should == "Twitter" }
      its(:developer_name)  { should == "Twitter, Inc." }

      it_behaves_like :not_null_properties
    end
  end

  describe "use stub content" do
    include_context :use_stub_content
    it_behaves_like :android_market_application_base_examples
  end

  describe "use real content", :content => "real"  do
    #include_context :save_content
    it_behaves_like :android_market_application_base_examples
  end
end
