### This is a Readme File About the Parser and Ruby
* Complete application works on the lamda function any changes will effect the pipelines 
* Application starts from the <mark> handler.rb </mark>
* So in order to have all dependecies we have keep the all the dependencies in Gemfile so that smooth execution can be there 
* for variable /params check spec_helper.rb
* When you use .match(regex), it returns a MatchData object, not an array. This object holds the full match and any capture groups.
---
* can_parse? checks wheather this file can be parsed or not >> specific file 
* feed_info.present? >> checks feeds is present >> calls fetch_and_set_feed_info? >> Altero:Base
* fetch_and_set_feed_info? >> sets the feed info >> cloudport_parser
* can_parse? -> loads_config -> config_key >> Altero::Base.channel_code
* No Special characters are allowed in output of the parser 
* Make sure you parameterize and underscore the values 
---
* Filepath/Fileextension and File are being set through intialize method of the cloudport 
* Working ::[Custom_file] XML_parser.parse_file() -1-> [ handler.rb <-- Application.rb ].params -2-> Altero::Base.initalize() [feed_Setup]
* [handler.rb <-- Application.rb ].parse() -3-> Altero::parser() -> itertate_over_rows() this is $block  
* Altero::parser() -4-> [cloudportParser < XML:SAX]
---
#### application.rb 
* in altero we have imported the packged in the application.rb which is then imported directly by importing  the application.rb in the current file
```ruby
# importing a pre-built package 
require 'base64'
require 'csv'
require 'config/blip_util'
# importing module from blip_util
include BlipUtil
```
---
## Altero  
<!-- altero/lib/altero/base.rb -->
#### base.rb
* 
```ruby
# from the configruation file 
# this line sets up multiple paramters of the parser wjich will parse the exact file 
Altero::Base.initialize(VERSION_V2, params)
# to make the string immutable 
# frozen_string_literal: true
# :nocov:
# module 
module Altero
  # import inside the module 
  # @ -> refers to the instance variable 
  # @@ -> refers to the class variable    
  require_relative "../../application"
  # class defination under the module
  # inheriting the cloudportParser
  class Base < cloudportParser
    # function with self means this is an instance function
    # for xml file reading we need to import nokogiri
    TAG_EPUB_ASSET_ID='EPUB_ASSET_ID'.freeze
    BUCKET_NAME="Aws.bucket.url".freeze
    # to define the attribute accessor of the class 
    attr_successor :file_path , :file_name 
    def self.initialize(version,params = {})
      # this variable is common for every class instance only one copy created    
      @@domain_name=params[:domain_name]
      # this vartiable is beolong to specific class instance different copy is created for different classes     
      @request_id =params[:reqeust_id]
      # values get set only when the condition got true means event["body"] is not null
      event = event["body"] if event["body"] 
      # embeded the var in the string "#{var_name}"   
      working_directory = "/temp/#{context.aws_reqeust_id}"
      DaznParser::TAG_EPUB_ASSET_ID

    end  

    # :domain_name act as key in hash structure 
    # event: act as named parameters 
    # @@ var can be accessed only through the geter fucntion 
    def self.domain_name 
      @@domain_name
    end    
```
---
#### handler.rb
```ruby
# importing our own file in ruby assuming the same directory
require_relative "application"
# define a function
# event: , context: are the name parameters 
# function is called as parse_file(event : event_name , context: context)
# event is the details of the event  who triggered the  function
# context refers to the env where the serveices are running like Aws lamda 
def parse_file(event:,context:)
  begin 
    # this code block where the exception works
    #  ways to access the fuction/vars of class    
    Altero::Base.logger.info("handler#parse_file: altero version: V1")
    #  condition testing  true when  that array  not contain the ENV["var"]
    if ["dev","test"].exclude?(ENV["SENTRY_ENVIRONMENT"])
        # code 
    end

      
  rescue
    # code error
  ensure 
    # this part of the code always runs  
end
```
---
### dazn_parser
* can_parse? -> feed_info_present? -> Alberto:Base.feed_info.present? && fetch_and_set_feed_info
* can_parse? -> load_config? -> load_config is used for making and bringing outthte s3 bucket from the user 
---
#### can_parse ? function 
* XML file is read by nokogiri parser
* This function tells either it can parse the given file or not 
* <mark> Aws::S3 </mark> for interacting with s3 bucket
---
```xml
<!-- <Starting_Tag>Content<Closing_Tag> -->
<event>
  <Schedule>
    <scheduleName="Match1" />
    <scheduleEnd="2025-04-10T12:00:00Z" />
  </Schedule>
</event>
```
---
```xml
<StartDateBroadcast>2025-04-03</StartDateBroadcast>
<StartTime>14:30:45</StartTime>
```
---
* play_on[0]  # "StartDateBroadcast>2025-04-03</StartDateBroadcast>"
* play_on[1]  # "2025-04-03"
* play_on_start_time[0]  # "StartTime>14:30:45</StartTime>"
* play_on_start_time[1]  # "14:30:45"
---
```ruby
# dummy function 
def can_regex_parse?
  play_on = first_few_chars.match(/StartDateBroadcast\>(.*)<\/StartDateBroadcast/)
  play_on_start_time = first_few_chars.match(/StartTime\>(.*)<\/StartTime/)


def can_parse?
  # aws-sdk-s3 
  # unless is the opposite version of the false     
  return false unless Altero::Base.extension == ".bxf"
  # logging the information through Altero module
  Altero::Base.logger.info("message")   
  return false unless self.feed_info_present?
  env_s3_config =JSON.parse(ENV["S3_CONFIG"]) if ENV["S3_CONFIG"]
  @s3=AWS::S3:Client.new()
  obj = @s3.get_object({
    bucket: BUCKET_NAME,
    key: config_key,
  })
  # converts the filename for the url freindly   
  self.epub_asset_id = filename.split(".").parameterize.underscore
  # reading the xml file with the regex
  Time.use_zone(Altero::Base.time_zone) do 
    char_str = self.first_1000_chars()
    # matches the Tag -> Schedule , scheduleName , scheduleEnd
    if char_str =~ /Schedule/ && char_Str =~ /scheduleName && char_str =~/scheduleEnd/
      schedule_name = char_str.match(/scheduleName=\"(.*?)\"/)
      schedule_start_date = schedule_name[1].match(/\d{4}-\d{2}-\d{2}/)
end  
```
---
* <mark> Creating a yield function </mark>
```ruby
def in_time_zone time_zone
  # yield is the function passed who called this mehod in_time_zone 
  Time.user_zone(time_zone) {yield}
end

def feed_broadcast_start_time_with_zone(date,broadcast_start_time,time_zone)
  self.in_time_zone time_zone do
    # this part of the code is passed as the yield
    return Time.zone.parse("method called")
  end
end    

```


---
### Parsing works 
* Parsing works in through mainly using four fucntions especially when
* --> iterate_over_rows(&block) --> read xml file row by row --> 
* --> start_element(element,attributes) --> reads out the starting tag of an element --><mark> <StartDate> </mark>
* --> characters(text) --> readout out  the content between the opening and the closing tag 
* --> end_element(text) --> readout out the ending tag of an element --><mark> </StartDate> </mark>
---
### iterate_over_rows function
* This Ruby method processes XML playlist data, modifies attributes, and stores formatted media item data. It also sets up a block (&block) to allow flexible behavior, initializes variables, and applies transformations.
* frame_rate_from_playlist.present?
* TAG_TILE :-> every var with TAG_VAR is mention in the config file 
---
### Regex Matching
* Regex pattern matching starts with  --> =~
* text =~ /^\d\d:\d\d:\d\d$/
* regular expression starts and end with /
* string starts with ^ and ends with $
* /d means a digit ranges [0:9]

```ruby
attr_accessor :callback , :items
# block is the part of the code 
def iterate_over_rows(&block)
  # using the parser for reading xml file 
  parser = Nokogiri::XML::SAX::Parser.new(self)
  # play_on contains two list one is play_on[0]--> matched object which is whole string and another is only captred group--> play_on[1]
  # item_stack = [{},{},{},{}]
  play_on = first_few_chars.match(/StartDateBroadcast\>(.*)<\/StartDateBroadcast/)
  #  this return index
  show_start_index = self.item_stack.index{|item| item[TAG_TYPE] == "show-start"}
  show_start=self.item_stack[show_start_index]
  show_start[TAG_STARTTIMETYPE] = "fixed"
  self.item_stack[show_start_index] = show_start
  # if the block is provided we will setup the self.callback = block
  self.callback=block
  self.items = []
  # traversing the list / array as item_in_hash   
  self.items.each do |item_in_hash|
    item_in_hash[TAG_TITLE]
    item_in_hash[TAG_ASSET_ID] = "#{item_in_hash[TAG_ASSET_ID]}_#{asset_increment}" if item_in_hash[TAG_MEDIA_TYPE] == "primary" && item_in_hash[TAG_TYPE] == "live"
    if item_in_hash[TAG_DURATION].present? && !item_in_hash[TAG_DURATION].is_a?(Integer)
end  

#  reads out the starting tag
def start_element(element,attributes)
  # hash the the 2d array in to a single array by using flatten for 2d to 1d arry conversion 
  attributes = Hash[*attributes.flatten]
  # push the element 
  self.element_stack << element
  if element == "Show"
    self.show_start = {TAG_TYPE => "show-start"}
  end
end  

# reds out the content b/w the tags of opeing and closing tags 
def characters(text)
  # same array but using it as a tag here   
  self.show_start[TAG_HOUR] = "#{self.temp_date} #{text} UTC" 
  #  returns the latest added element in the stack 
  case self.element_Stack[-1]
  when "StartTime"
    # No require for the break statements
  when "MediaID"
  end
end    
```
---
### Test Cases Handling 
* Use spec folder we have spec_helper where we have Rspec configurations and mock_helper for the mocking the methods 
* Rspec file used for configuration the things 
* anthemxml_show_items --> returns the expected result for testing 
* anthemxml_feed_info --> sends the feed info 
* all_expectations --> is the fucntion where we check out the output and the expected output 
---
### Mock Helper 
```ruby
# mocking the api 
module MockHelper
  def mock_feeds_index_api(response,channel_code,channel_name,response_code=200)
    params = if channel_code.present?
      {channel_code: channel_code}
    elsif channel_name.present?
      { channel_name: channel_name}
    end
    
    request_url = "https://hostname/v1/api/feeds.json"
    # mock a get request of  request_url .with body verfication and .to_return sending back response of api
    stub.request(:get,request_url)
      .with(body: hash_including(params))
      .to_return(status: response_code,body: response)
  end
end

require "spec_helper"
require_relative "mock_helper"

# test case files
describe  AnthemXmlParser do 
  include MockHelper
  # verifying function 
  def all_expectations(parser,items_expected=[],play_on="",length=0,feed="0")
    # falls on the false value 
    expect(parser.can_parser?).to be_truthy
    expect(parser.get_play_on.to_s).to eq(play_on)
    expect(parser.valid_play_on?).to be_truthy
    
    #  this function calls the parser function where that &block is passed by  through this invoking function
    count =0
    parser.iterate_over_rows do |item|
      if items_expected[count].present?
        expect(item).to eq(items_expected[count])
      end
      count+=1
    end
    
    expect(count).to eq(length)
  end  
  
  # this is the expected  parsed valued 
  def anthemxml_show_items 
    [
      {
        "TYPE"=>"show-start",
        "START TIME TYPE" => "fixed",
        "MEDIA TYPE" =>"show",
        "HOUR"=>"2022-01-21 03:00:00.000 UTC",
        "DURATION"=>"00:30:00:00",
        "ASSET ID"=>"Vms",
      },
      {
        "HOUR"=>"2022-01-21 03:00:00.000 UTC",
        "ASSET ID"=>"V6",
        "TITLE"=>"The Very VERY Best of the 70s #206: Late 70s Sitcoms",
        "DURATION"=>"00:30:00:00",
      },
      {
        "TYPE"=>"show-end",
        "MEDIA TYPE" =>"show",
      },
    ]
  end

  # actual test case with description 
  it "should parse xml playlist and create a playlist" do
    Time.use_zone("Africa/Addis_Ababa") do 
      filename = "Choice Tv playlist.xml"
      # this file is xontains the actual location where the xml data is there which need to be parsed
      playlist_path = File.join(Dir.pwd, "spec", "playlistparser", "sample", "anthem", "anthem_playlist.xml")
      # setup altero --> setting up feed_info
      setup_altero(playlist_path,self.feed_info)
      # setup parser 
      paser=AnthemXMLParser.new(playlist_path)
      #  validation fucntion 
      all_expectations(parser, self.anthemxml_show_items, "2022-01-21 03:00:00.000 UTC", 81, "")
    end
  end

end    
```








