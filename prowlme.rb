$: << File.join(File.dirname(__FILE__), 'lib')
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

  def self.i18n_config
    return @@i18n_config if defined? @@i18n_config 
    i18n_config = File.join(File.dirname(__FILE__), 'config/i18n')
    @@i18n_config = YAML.load_file(i18n_config)
    @@i18n_config
  end
end

helpers do 
  def i18n(msg)
    lang = ProwlSMS::config['lang'] || 'en'
    ProwlSMS::i18n_config[msg][lang] || msg
  end
end

post '/send' do
  halt(401, "Texto no válido") unless captcha_pass?
  p = Prowl.new(config['apikey'].to_s)
  p.send(:application => (params['from'] || 'unknown'), :event => (params['subject'] || 'no subject'), :description => (params['text'] || 'no text'))
  haml :sent
end

get '/' do
  @apptitle = ProwlSMS::config['apptitle'] || 'ProwlSMS by Sergio Rubio'
  haml :index
end
