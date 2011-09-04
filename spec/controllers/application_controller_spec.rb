require 'spec_helper'

describe ApplicationController do
  controller do
    def index
      render :nothing => true
    end
  end

  describe "GET 'index'" do
    it "should redirect to a mobile domain when given an appropriate user agent" do
      request.env["HTTP_USER_AGENT"] = "Mozilla/5.0 (iPhone; U; XXXXX like Mac OS X; en) AppleWebKit/420+ (KHTML, like Gecko) Version/3.0 Mobile/241 Safari/419.3 |"
      get :index
      response.location.split("http://")[1].split(".")[0].should eq(MobilePath.config.subdomain)
    end

    it "should redirect to a configured domain as well." do
      request.env["HTTP_USER_AGENT"] = "Mozilla/5.0 (iPhone; U; XXXXX like Mac OS X; en) AppleWebKit/420+ (KHTML, like Gecko) Version/3.0 Mobile/241 Safari/419.3 |"
      MobilePath.configure do |config|
        config.subdomain = "mobizzle"
      end
      get :index
      response.location.split("http://")[1].split(".")[0].should eq("mobizzle")
    end

    it "shouldn't redirect on a normal user agent" do
      request.env["HTTP_USER_AGENT"] = "Test"
      get :index
      response.location.should be_false
    end

    it "shouldn't redirect on a mobile user agent with a full_site param" do
      request.env["HTTP_USER_AGENT"] = "Mozilla/5.0 (iPhone; U; XXXXX like Mac OS X; en) AppleWebKit/420+ (KHTML, like Gecko) Version/3.0 Mobile/241 Safari/419.3 |"
      get :index, {:full_site => true}
      response.location.should be_false

      get :index, {:mobile_site => true}
      response.location.split("http://")[1].split(".")[0].should eq(MobilePath.config.subdomain)
    end

    it "should not fail if mobile subdomain is empty" do
      MobilePath.config.subdomain=""
      request.env["HTTP_USER_AGENT"] = "Mozilla/5.0 (iPhone; U; XXXXX like Mac OS X; en) AppleWebKit/420+ (KHTML, like Gecko) Version/3.0 Mobile/241 Safari/419.3 |"
      get :index, {:mobile_site => true}
      debugger
      response.location.should eq("http://test.host/stub_resources?mobile_site=true")
    end

  end

end
