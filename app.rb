#!/usr/bin/env ruby

require 'sinatra'
require 'nokogiri'
require_relative 'classes/markr_db'
require 'ruby_native_statistics'
require 'json'
require 'erb'

class MarkrApp < Sinatra::Base
    attr_reader :markr_db
    markr_db = MarkrDB.new

    set :raise_errors, false
    set :show_exceptions, false

    configure do
        mime_type :markr_mime_type, 'text/xml+markr'
    end

    # Homepage
    get '/' do
        content_type :markr_mime_type
        'Markr as a Service'
    end

    # Upload test result to http server
    post '/import' do
        if request.content_type == 'text/xml+markr'
            @data = Nokogiri::XML(request.body.read)
            
            @data.xpath('//mcq-test-result').each do |result|
                # get the data
                @first_name = result.at_xpath('first-name').content
                @last_name = result.at_xpath('last-name').content
                @student_id = result.at_xpath('student-number').content
                @test_id = result.at_xpath('test-id').content
                @questions_available = result.at_xpath('summary-marks').get_attribute "available"
                @questions_obtained = result.at_xpath('summary-marks').get_attribute "obtained"
               
                if @first_name.empty? or @last_name.empty? or @student_id.empty? or @test_id.empty? or @questions_available.empty? or @questions_obtained.empty?
                    # redirect to /invalid page and reject the file
                    content_type :markr_mime_type
                    puts @data
                    redirect '/invalid'
                else
                    # insert into database
                    markr_db.insert_result(@student_id,@first_name,@last_name,@test_id,@questions_available,@questions_obtained)
                    
                end
            end
            
        else
            # Raise an error page
            halt 406, "Invalid header content file."
        end    
    end

    get '/invalid' do
        'There is/are missing information in the data, please enter manually.'
    end

    # request for test statistic for data aggregation
    get '/results/:test_id/aggregate' do |test_id|
        # view the data
        content_type 'application/json'

        scores = markr_db.get_test_results(test_id)
        if scores.size == 1
            stddev = 0.0
        else
            stddev = (scores.stdev).round(1)
        end
        
        results = {:mean => (scores.mean).round(1), 
            :stddev => stddev, 
            :min => scores.min, 
            :max => scores.max, 
            :p25 => (scores.percentile(0.5)).round(1), 
            :p50 => (scores.median).round(1),
            :p75 => (scores.percentile(0.75)).round(1), 
            :count => scores.count}

        JSON.generate(results)
    end
end

MarkrApp.run!


