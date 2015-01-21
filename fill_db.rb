#!/usr/bin/env ruby

require 'data_mapper'
require 'csv'

if __FILE__ == $0

    if ARGV.length != 1
        puts 'Usage: script.rb <database_url>'
        exit
    end

    db_url = ARGV[0]

    puts "connecting to #{db_url}"
    DataMapper.setup(:default, db_url)
    require_relative 'app/models'
    DataMapper.finalize
    DataMapper.auto_migrate!

    for quarter in 1..4
        puts "Processing #{quarter} quarter"
        shows = CSV.read("csv/#{quarter}/impressions_#{quarter}.csv")
        shows.shift
        clicks = CSV.read("csv/#{quarter}/clicks_#{quarter}.csv")
        clicks.shift
        conversions = CSV.read("csv/#{quarter}/conversions_#{quarter}.csv")
        conversions.shift
        puts "  Found #{shows.length} shows, #{clicks.length} clicks and #{conversions.length} conversions"

        puts "  Processing shows..."
        shws = {}
        i = 0
        shows.each do |bid,cid|
            if shws[[bid,cid]] == nil
                shws[[bid,cid]] = 1
            else
                shws[[bid,cid]] += 1
            end
        end
        shws.each do |k,v|
            printf("%d of %d\r", i, shws.length)
            show = Show.create(:banner => k[0], :campaign => k[1], :quarter => quarter, :counter => v)
            i = i + 1
        end
        puts "\n  done."

        puts "  Processing clicks..."
        clks = {}
        clicks.each do |clid,bid,cid|
            clks[clid] = [bid, cid]
        end

        puts "  Processing conversions..."
        conversions.each do |conv_id,clid,revenue|
            clks[clid] << revenue
        end
        puts "  Saving clicks to db..."
        i = 0
        clks.each do |k,v|
            printf("%d of %d\r", i, clks.length)
            Click.create(
                :id => k,
                :banner => v[0],
                :campaign => v[1],
                :quarter => quarter,
                :revenue => v[2]
            )
            i += 1
        end

        puts "\n  done."
    end
end
