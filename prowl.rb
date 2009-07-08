#! /usr/bin/ruby

# A ruby class for sending notifications to Prowl.

require 'uri'
require 'net/http'
require 'net/https'

class String
  def urlencode
    gsub( /[^a-zA-Z0-9\-_\.!~*'()]/n ) {|x| sprintf('%%%02x', x[0]) }
  end
end

class Hash
  def urlencode
    collect { |k,v| "#{k.to_s.urlencode}=#{v.to_s.urlencode}" }.join('&')
  end
end

class Prowler
  def initialize user, pass
    @url = URI.parse('https://prowl.weks.net/api/add_notification.php')
    @username = user
    @password = pass
    
    @http = Net::HTTP.new(@url.host, @url.port)
    @http.use_ssl = true
  end

  def send_notification app, evt, desc
    

    options = {
      'application' => app,
      'event' => evt,
      'description' => desc
    }
    
    req = Net::HTTP::Get.new("#{@url.path}?#{options.urlencode}")
    req.basic_auth @username, @password
    @http.request(req)
  end

end
