# -*- coding: utf-8 -*-
require 'spec_helper'

describe AndroidMarket do
  before(:all) do
    # for more than fast test!
    AndroidMarket::APP_COUNT_IN_PAGE = 1
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

      context "each GAME_CATEGORIES" do
        where(:category) do
          AndroidMarket::GAME_CATEGORIES.product
        end

        with_them do
          it{ should be_an_instance_of AndroidMarketApplication }
        end
      end

      context "each APPLICATION_CATEGORIES" do
        where(:category) do
          AndroidMarket::APPLICATION_CATEGORIES.product
        end

        with_them do
          it{ should be_an_instance_of AndroidMarketApplication }
        end
      end
    end

    describe "#get_top_selling_paid_app_in_category" do
      subject { AndroidMarket.get_top_selling_paid_app_in_category(category, position, options) }

      it{ should be_an_instance_of AndroidMarketApplication }

      context "each GAME_CATEGORIES" do
        where(:category) do
          AndroidMarket::GAME_CATEGORIES.product
        end

        with_them do
          it{ should be_an_instance_of AndroidMarketApplication }
        end
      end

      context "each APPLICATION_CATEGORIES" do
        where(:category) do
          AndroidMarket::APPLICATION_CATEGORIES.product
        end

        with_them do
          it{ should be_an_instance_of AndroidMarketApplication }
        end
      end
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

  describe "GAME_CATEGORIES", :content => "real" do
    where(:category) do
      AndroidMarket::GAME_CATEGORIES.inject([]){|array, category| array << [category]; array }
    end

    with_them do
      it "get_top_selling_free_app_in_category should be success" do
        AndroidMarket.get_top_selling_free_app_in_category(category, position)
      end

      it "get_top_selling_paid_app_in_category should be success" do
        AndroidMarket.get_top_selling_paid_app_in_category(category, position)
      end
    end
  end

  describe "APPLICATION_CATEGORIES", :content => "real" do
    where(:category) do
      AndroidMarket::APPLICATION_CATEGORIES.inject([]){|array, category| array << [category]; array }
    end

    with_them do
      it "get_top_selling_free_app_in_category should be success" do
        AndroidMarket.get_top_selling_free_app_in_category(category, position)
      end

      it "get_top_selling_paid_app_in_category should be success" do
        AndroidMarket.get_top_selling_paid_app_in_category(category, position)
      end
    end
  end
end
