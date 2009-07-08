require 'rubygems'
require 'sinatra'
require 'prowl'
require 'yaml'
require 'haml'

config_file = File.join(File.dirname(__FILE__), 'config')
config = YAML.load_file(config_file)

post '/send' do
  p = Prowler.new(config['username'], config['password'])
  p.send_notification(params['from'] || 'unknown',params['subject'] || 'no subject', params['text'] || 'no text')
  haml :sent
end

get '/' do
  haml :index
end
