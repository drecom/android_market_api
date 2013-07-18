# -*- coding: utf-8 -*-
require 'spec_helper'

describe AndroidMarket do
  before(:all) do
    # for more than fast test!
    AndroidMarket::APP_COUNT_IN_PAGE = 1
  end

  describe "#get_application_categories" do
    subject { AndroidMarket.get_application_categories }

    it{ should have_at_least(1).items }
    it{ should include "BOOKS_AND_REFERENCE" }
  end

  describe "#get_languages" do
    subject { AndroidMarket.get_languages }

    it{ should have_at_least(1).items }
    it{ should include "en" }
  end

  describe "#get_game_categories" do
    subject { AndroidMarket.get_game_categories }

    it{ should have_at_least(1).items }
    it{ should include "ARCADE" }
  end

  let(:category) { "BOOKS_AND_REFERENCE" }
  let(:position) { 1 }
  let(:options) do
    {
        :language => "en",
        :proxy => nil,
        :header => {
            "User-Agent" => "ruby",
        }
    }
  end
  let(:developer_name) { "Google Inc." }

  shared_examples_for :android_market_base_examples do
    describe "#get_top_selling_free_app_in_category" do
      subject { AndroidMarket.get_top_selling_free_app_in_category(category, position, options) }

      it{ should be_an_instance_of AndroidMarketApplication }
    end

    describe "#get_top_selling_paid_app_in_category" do
      subject { AndroidMarket.get_top_selling_paid_app_in_category(category, position, options) }

      it{ should be_an_instance_of AndroidMarketApplication }
    end

    describe "#get_overall_top_selling_free_app" do
      subject { AndroidMarket.get_overall_top_selling_free_app(position, options) }

      it{ should be_an_instance_of AndroidMarketApplication }
    end

    describe "#get_overall_top_selling_paid_app" do
      subject { AndroidMarket.get_overall_top_selling_paid_app(position, options) }

      it{ should be_an_instance_of AndroidMarketApplication }
    end

    describe "#get_overall_top_selling_new_paid_app" do
      subject { AndroidMarket.get_overall_top_selling_new_paid_app(position, options) }

      it{ should be_an_instance_of AndroidMarketApplication }
    end

    describe "#get_overall_top_selling_new_free_app" do
      subject { AndroidMarket.get_overall_top_selling_new_free_app(position, options) }

      it{ should be_an_instance_of AndroidMarketApplication }
    end

    describe "#get_developer_app_list" do
      subject { AndroidMarket.get_developer_app_list(developer_name, position, options) }

      it{ should array_instance_of AndroidMarketApplication }
    end

    describe "#get_top_selling_free_apps_in_category" do
      subject { AndroidMarket.get_top_selling_free_apps_in_category(category, position, options) }

      it{ should array_instance_of AndroidMarketApplication }
      it{ should have_exactly(AndroidMarket::APP_COUNT_IN_PAGE).apps }
    end

    describe "#get_top_selling_paid_apps_in_category" do
      subject { AndroidMarket.get_top_selling_paid_apps_in_category(category, position, options) }

      it{ should array_instance_of AndroidMarketApplication }
      it{ should have_exactly(AndroidMarket::APP_COUNT_IN_PAGE).apps }
    end

    describe "#get_overall_top_selling_free_apps" do
      subject { AndroidMarket.get_overall_top_selling_free_apps(position, options) }

      it{ should array_instance_of AndroidMarketApplication }
      it{ should have_exactly(AndroidMarket::APP_COUNT_IN_PAGE).apps }
    end

    describe "#get_overall_top_selling_paid_apps" do
      subject { AndroidMarket.get_overall_top_selling_paid_apps(position, options) }

      it{ should array_instance_of AndroidMarketApplication }
      it{ should have_exactly(AndroidMarket::APP_COUNT_IN_PAGE).apps }
    end

    describe "#get_overall_top_grossing_apps" do
      subject { AndroidMarket.get_overall_top_grossing_apps(position, options) }

      it{ should array_instance_of AndroidMarketApplication }
      it{ should have_exactly(AndroidMarket::APP_COUNT_IN_PAGE).apps }
    end

    describe "#get_overall_top_selling_new_paid_apps" do
      subject { AndroidMarket.get_overall_top_selling_new_paid_apps(position, options) }

      it{ should array_instance_of AndroidMarketApplication }
      it{ should have_exactly(AndroidMarket::APP_COUNT_IN_PAGE).apps }
    end

    describe "#get_overall_top_selling_new_free_apps" do
      subject { AndroidMarket.get_overall_top_selling_new_free_apps(position, options) }

      it{ should array_instance_of AndroidMarketApplication }
      it{ should have_exactly(AndroidMarket::APP_COUNT_IN_PAGE).apps }
    end

    describe "#get_developer_app_list" do
      subject { AndroidMarket.get_developer_app_list(developer_name, position, options) }

      it{ should array_instance_of AndroidMarketApplication }
    end
  end

  describe "use stub content" do
    include_context :use_stub_content
    it_behaves_like :android_market_base_examples
  end

  describe "use real content", :content => "real"  do
    #include_context :save_content
    it_behaves_like :android_market_base_examples
  end

  describe "should paging", :content => "real"  do
    context "category" do
      let(:app1){ AndroidMarket.send(get_app, category, 1) }
      let(:app2){ AndroidMarket.send(get_app, category, 2) }

      describe "#get_top_selling_free_app_in_category" do
        subject(:get_app){ :get_top_selling_free_app_in_category }

        it{ app1.package.should_not == app2.package }
      end

      describe "#get_top_selling_paid_app_in_category" do
        subject(:get_app){ :get_top_selling_paid_app_in_category }

        it{ app1.package.should_not == app2.package }
      end
    end

    context "overall" do
      let(:app1){ AndroidMarket.send(get_app, 1) }
      let(:app2){ AndroidMarket.send(get_app, 2) }

      describe "#get_overall_top_selling_free_app" do
        subject(:get_app){ :get_overall_top_selling_free_app }

        it{ app1.package.should_not == app2.package }
      end

      describe "#get_overall_top_selling_paid_app" do
        subject(:get_app){ :get_overall_top_selling_paid_app }

        it{ app1.package.should_not == app2.package }
      end

      describe "#get_overall_top_grossing_app" do
        subject(:get_app){ :get_overall_top_grossing_app }

        it{ app1.package.should_not == app2.package }
      end

      describe "#get_overall_top_selling_new_paid_app" do
        subject(:get_app){ :get_overall_top_selling_new_paid_app }

        it{ app1.package.should_not == app2.package }
      end

      describe "#get_overall_top_selling_new_free_app" do
        subject(:get_app){ :get_overall_top_selling_new_free_app }

        it{ app1.package.should_not == app2.package }
      end
    end
  end
end
