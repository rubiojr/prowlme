require 'rubygems'
require 'sinatra'
require 'sinatra/captcha'
require 'prowl'
require 'yaml'
require 'haml'

config_file = File.join(File.dirname(__FILE__), 'config/settings')
config = YAML.load_file(config_file)

module ProwlSMS
  def self.config
    return @@config if defined? @@config 
    config_file = File.join(File.dirname(__FILE__), 'config/settings')
    @@config = YAML.load_file(config_file)
    @@config
  end
end

post '/send' do
  halt(401, "Texto no válido") unless captcha_pass?
  p = Prowler.new(config['username'], config['password'])
  p.send_notification(params['from'] || 'unknown',params['subject'] || 'no subject', params['text'] || 'no text')
  haml :sent
end

get '/' do
  @apptitle = ProwlSMS::config['apptitle'] || 'ProwlSMS by Sergio Rubio'
  haml :index
end
