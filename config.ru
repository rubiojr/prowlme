# To use with thin 
#  thin start -p PORT -R config.ru

require File.join(File.dirname(__FILE__), 'prowlme.rb')

disable :run
set :environment, :producction
run Sinatra::Application
