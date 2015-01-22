require 'grape'

module Advidi
  class API < Grape::API

    format :json

    helpers do
      def current_quarter
        1 + (Time.now.min / 15)
      end

      def parse_cookie(value)
        begin
          #return value.split('_').map! {|x| x.to_i}[0..9]
          return value.to_i
        rescue
          return 0
        end
      end

      def pick_random(exceptions)
        p = rand(100..500)
        while exceptions.index(p) != nil
          p = rand(100..500)
        end
        return p
      end
    end

    resource :campaigns do

      desc "Return a list of banners for specified campaign."
      params do
        requires :campaign_id, type: Integer
      end
      get 'api/:campaign_id' do
        # determine quarter of hour
        quarter = current_quarter
        recent_banner = parse_cookie(cookies[:recent_banner])

        # try to get top banners based on revenue/shows rate (first priority) and clicks/shows rate (second priority)
        # have to use a raw query to order by aggregated field
        banners = repository(:default).adapter.select(
          'SELECT banner, rev, clk, shw FROM (
            SELECT banner, sum(revenue) rev, count(id) clk, (
               SELECT counter FROM shows
               WHERE (shows.quarter=clicks.quarter AND shows.campaign=clicks.campaign AND clicks.banner=shows.banner)
             ) shw 
            FROM clicks
            WHERE (quarter=? AND campaign=? AND banner != ? ) GROUP BY banner) t
           ORDER BY rev/shw DESC, (clk * 1.0)/shw DESC LIMIT 10',
          quarter, params['campaign_id'], recent_banner
        )

        # don't show more than 5 click-based banners
        last_index = [5, banners.length].min
        while last_index < banners.length and banners[last_index].rev != nil
          last_index += 1
        end
        banners.slice!(last_index)
        banners.map!{|x| x.banner}

        # if not enough banners, add random banners
        more_banners = 5 - banners.length
        for i in 1..more_banners
          banners << pick_random(banners + [recent_banner])
        end

        banner = banners.sample

        cookies[:recent_banner] = {
          value: banner,
          path: '/'
        }
        { :banner => banner }
      end
    end
  end
end


