# -*- coding: utf-8 -*-
require 'spec_helper'

describe AndroidMarketApi::Util do

  describe "#sanitize" do
    subject { AndroidMarketApi::Util.sanitize(str) }

    let(:str) { "aaa<br>bbb<br/>ccc<p>ddd</p>eee<br />" }

    it "should sanitize" do
      should == <<EOS
aaa
bbb
ccc ddd eee
EOS
    end
  end

  describe "#get_content" do
    subject { AndroidMarketApi::Util::get_content(url, options) }

    let(:url) { "http://www.google.com/" }

    context "no options" do
      let(:options){ {} }
      it{ should have_at_least(1).characters }
    end

    context "exists User-Agent" do
      let(:options) do
        {
            :header => {
                "User-Agent" => "Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A403 Safari/8536.25",
            }
        }
      end

      # if exists smartphone user-agent, get smartphone content from google
      let(:google_smartphone_header){ %{<meta name="format-detection" content="address=no">} }
      it{ should be_include google_smartphone_header }
    end

    context "exists proxy" do
      context "valid proxy" do
        let(:options) { {:proxy => "http://your.proxy.url/" } }

        it {
          pending "specify your proxy url"
          should have_at_least(1).characters
        }
      end

      context "invalid proxy" do
        subject { AndroidMarketApi::Util::get_content(url, options) }

        let(:options) { {:proxy => "http://your.proxy.url/" } }

        it{ expect{subject}.to raise_error }
      end
    end
  end
end