# To use with thin 
#  thin start -p PORT -R config.ru

require File.join(File.dirname(__FILE__), 'prowl.rb')
require File.join(File.dirname(__FILE__), 'prowlsms.rb')

disable :run
set :environment, :producction
run Sinatra::Application
