#!/usr/bin/env ruby
# Bit.ly Shortner helper binary as this is getting fucking annoying and tedious
require 'rubygems'
require 'bitly'
require 'curb'
require 'cgi'
require 'json'

class MissingConfiguration < Exception; end
class InvalidConfiguration < Exception; end
class MalformedURL         < Exception; end
class MissingInput         < Exception; end


class Shrt
  attr_accessor :api_key, :username, :client, :url, :short_url, :bitly_obj
  
  API_BASE_URL    = "https://api-ssl.bitly.com/v3/"
  URI_MATCHER     = /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix

  
  # FORCE VERSION 3 API
  Bitly.use_api_version_3

  
  def initialize(url)    
    @url = url
    if File.exists?(File.expand_path('~/.bitly'))
      config   = YAML.load(File.open(File.expand_path("~/.bitly")))
      if config.keys.all? {|k| (k == :username || k == :api_key) && !config[k].empty? }
        @username = config[:username]
        @api_key  = config[:api_key]       
      else
        raise InvalidConfiguration.new("Your ~/.bitly file was incorrectly setup , it must be correctly formmated YAML with your API key and Username")
      end
    else
      raise MissingConfiguration.new("Configuration for bitly bin missing")
    end
    
    if !url.match(URI_MATCHER)
      raise MalformedURL.new("The URL Suppplied: #{url} Did pass as a valid url")
    end
  end



  def shorten_it!
    url = CGI.escape(@url)
    auth_params = "login=#{username}&apiKey=#{api_key}"
    path = "#{API_BASE_URL}shorten?#{auth_params}&longUrl=#{url}"
    
    call = Curl::Easy.new(path)
    call.perform
    response_code = call.response_code.to_i 
    response_body = call.body_str
    
    if response_code == 200
      body = call.body_str
      body = JSON.parse(body)
      
      if body["status_code"].to_i == 200
        @short_url = body["data"]["url"]
      elsif body["status_code"].to_i == 500
        if body["status_txt"] == "INVALID_APIKEY"
          msg "Your APIKEY Username Combination was not recognized. The Server brilliantly"
          msg += " responded with a 200 but in a status message said 500, the request was unable to complete. "
          msg += " Check you credenrtials."
          exit
        else
          puts "Failed Request , Serever Failure"
          exit
        end 
      else
        puts "Please Check the Bitly API Documentation."
        puts "Here is the resopnse information to help:"
        puts "STATUS CODE: #{body["status_code"]}"
        exit
      end   
      # BRILLIAND IMPLEMENTATION, instead of returning a 400 or a normal auth related http code incorrect credentials 
      # return 200's and in the body it tells you you made a mistake ...brilliant thats 'creative'
    elsif response_code 301
      puts "URS/Endpoints In The API have Changed, Gem Is no longer compatible"
      exit
    elsif response_code == 500
      puts "Failed Request , Serever Failure"
    else
      puts "Please Check the Bitly API Documentation."
      puts "Here is the resopnse information to help:"
      puts "STATUS CODE: #{body["status_code"]}"
      exit   
    end  
  end
end