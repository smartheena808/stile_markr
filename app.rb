#!/usr/bin/env ruby

require 'sinatra'
require 'nokogiri'
require_relative 'classes/markr_db'
require 'ruby_native_statistics'
require 'json'


markr_db = MarkrDB.new

configure do
    mime_type :markr_mime_type, 'text/xml+markr'
end

get '/' do
    content_type :markr_mime_type
    'Markr as a Service'
end

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
            # insert into database
            markr_db.insert_result(@student_id,@first_name,@last_name,@test_id,@questions_available,@questions_obtained)
            
        end
        
    else
        # TODO reject with nice format and print out the file
        'Data is not match!'
    end    
end

get '/results/:test_id/aggregate' do |test_id|
    # view the data
    content_type 'application/json'

    scores = markr_db.get_test_results(test_id)
    
    results = {:mean => scores.mean, 
        :stddev => (scores.stdev).round(1), 
        :min => scores.min, 
        :max => scores.max, 
        :p25 => (scores.percentile(0.5)).round(1), 
        :p50 => (scores.median).round(1),
        :p75 => (scores.percentile(0.75)).round(1), 
        :count => scores.count}

    JSON.generate(results)
end
