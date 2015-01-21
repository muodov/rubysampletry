require 'data_mapper'

class Show
  include DataMapper::Resource
  
  property :id,       Serial
  property :banner,   Integer, :index => :banner_campaign_quarter
  property :campaign, Integer, :index => :banner_campaign_quarter
  property :quarter,  Integer, :index => :banner_campaign_quarter
  property :counter,  Integer, :default => 0

end

class Click
  include DataMapper::Resource

  property :id,       Serial    # click_id
  property :banner,   Integer   # banner_id
  property :campaign, Integer, :index => :campaign_quarter   # campaign_id
  property :quarter,  Integer, :index => :campaign_quarter   # quarter of the hour (0-3)
  property :revenue,  Float,   :index => true

end

