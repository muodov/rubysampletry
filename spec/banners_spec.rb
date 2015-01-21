require 'rspec'
require 'rack/test'
ENV['RACK_ENV'] = 'test'
require_relative '../app/config'
require_relative '../app/api'

describe Advidi::API do
  include Rack::Test::Methods

  def app
    Advidi::API
  end

  describe Advidi::API do
    before(:all) do
      @quarter = 1 + (Time.now.min / 15)
      
      Show.create(:banner => 1,  :campaign => 1, :quarter => @quarter, :counter => 5)
      Show.create(:banner => 2,  :campaign => 1, :quarter => @quarter, :counter => 1)
      Show.create(:banner => 3,  :campaign => 1, :quarter => @quarter, :counter => 1)
      Show.create(:banner => 4,  :campaign => 1, :quarter => @quarter, :counter => 1)
      Show.create(:banner => 5,  :campaign => 1, :quarter => @quarter, :counter => 1)
      Show.create(:banner => 6,  :campaign => 1, :quarter => @quarter, :counter => 1)
      Show.create(:banner => 7,  :campaign => 1, :quarter => @quarter, :counter => 1)
      Show.create(:banner => 8,  :campaign => 1, :quarter => @quarter, :counter => 1)
      Show.create(:banner => 9,  :campaign => 1, :quarter => @quarter, :counter => 1)
      Show.create(:banner => 10, :campaign => 1, :quarter => @quarter, :counter => 1)
      Show.create(:banner => 11, :campaign => 1, :quarter => @quarter, :counter => 1)
      Show.create(:banner => 12, :campaign => 1, :quarter => @quarter, :counter => 1)
      Click.create(:banner => 1,  :campaign => 1, :quarter => @quarter, :revenue => 1.0)
      Click.create(:banner => 2,  :campaign => 1, :quarter => @quarter, :revenue => 0.5)
      Click.create(:banner => 3,  :campaign => 1, :quarter => @quarter, :revenue => 1.0)
      Click.create(:banner => 4,  :campaign => 1, :quarter => @quarter, :revenue => 1.0)
      Click.create(:banner => 5,  :campaign => 1, :quarter => @quarter, :revenue => 1.0)
      Click.create(:banner => 6,  :campaign => 1, :quarter => @quarter, :revenue => 1.0)
      Click.create(:banner => 7,  :campaign => 1, :quarter => @quarter, :revenue => 1.0)
      Click.create(:banner => 8,  :campaign => 1, :quarter => @quarter, :revenue => 1.0)
      Click.create(:banner => 9,  :campaign => 1, :quarter => @quarter, :revenue => 1.0)
      Click.create(:banner => 10, :campaign => 1, :quarter => @quarter, :revenue => 1.0)
      Click.create(:banner => 11, :campaign => 1, :quarter => @quarter, :revenue => 1.0)
      Click.create(:banner => 12, :campaign => 1, :quarter => @quarter, :revenue => 1.0)

      Show.create(:banner => 1, :campaign => 2, :quarter => @quarter, :counter => 100)
      Show.create(:banner => 2, :campaign => 2, :quarter => @quarter, :counter => 100)
      Show.create(:banner => 3, :campaign => 2, :quarter => @quarter, :counter => 2)
      Show.create(:banner => 4, :campaign => 2, :quarter => @quarter, :counter => 2)
      Show.create(:banner => 5, :campaign => 2, :quarter => @quarter, :counter => 2)
      Show.create(:banner => 6, :campaign => 2, :quarter => @quarter, :counter => 2)
      Show.create(:banner => 7, :campaign => 2, :quarter => @quarter, :counter => 2)
      Click.create(:banner => 1, :campaign => 2, :quarter => @quarter, :revenue => 1.0)
      Click.create(:banner => 2, :campaign => 2, :quarter => @quarter)
      Click.create(:banner => 4, :campaign => 2, :quarter => @quarter)
      Click.create(:banner => 5, :campaign => 2, :quarter => @quarter)
      Click.create(:banner => 6, :campaign => 2, :quarter => @quarter)
      Click.create(:banner => 7, :campaign => 2, :quarter => @quarter)
      Click.create(:banner => 7, :campaign => 2, :quarter => @quarter)
      
      Show.create(:banner => 1, :campaign => 3, :quarter => @quarter, :counter => 1)
      Show.create(:banner => 2, :campaign => 3, :quarter => @quarter, :counter => 1)
      Click.create(:banner => 1, :campaign => 3, :quarter => @quarter)
      Click.create(:banner => 2, :campaign => 3, :quarter => @quarter)
    end

    it "returns five random banners for notexistent campaign" do
      get "/campaigns/api/100"
      expect(last_response.status).to eq(200)
      expect(JSON.parse(last_response.body)['banners'].length).to eq(5)
    end

    it "returns up to ten banners with the largest revenue/shows, if those exist" do
      get "/campaigns/api/1"
      expect(last_response.status).to eq(200)
      banners = JSON.parse(last_response.body)['banners']
      expect(banners.length).to eq(10)
      expect(banners.sort).to eq([3,4,5,6,7,8,9,10,11,12])
    end

    it "if there is not enough banners with revenue, return banners with maximum clicks/shows" do
      get "/campaigns/api/2"
      expect(last_response.status).to eq(200)
      banners = JSON.parse(last_response.body)['banners']
      expect(banners.length).to eq(5)
      expect(banners.sort).to eq([1,4,5,6,7])
    end

    it "if there is not enough banners with clicks, return random banners" do
      get "/campaigns/api/3"
      expect(last_response.status).to eq(200)
      banners = JSON.parse(last_response.body)['banners']
      expect(banners.length).to eq(5)
      expect(banners.include?(1)).to be true
      expect(banners.include?(2)).to be true
    end

    it "doesn't return the same banners twice in a row" do
      get "/campaigns/api/1"
      puts rack_mock_session.cookie_jar.to_hash
      expect(last_response.status).to eq(200)
      banners = JSON.parse(last_response.body)['banners']
      expect(banners.length).to eq(10)
      expect(banners.sort).to eq([3,4,5,6,7,8,9,10,11,12])
      get "/campaigns/api/1"
      banners1 = JSON.parse(last_response.body)['banners']
      expect(banners1.length).to eq(5)
      banners.each do |recent_banner|
        expect(banners1.include?(recent_banner)).to be false
      end
    end

  end
end
