require 'sinatra'
require 'rubygems'
require 'aws/s3'

include AWS::S3

enable :sessions

s3_config = YAML::load( File.open( 'config/s3.yml' ) )
  
set :bucket, s3_config['S3_BUCKET']
set :s3_key, s3_config['S3_KEY']
set :s3_secret, s3_config['S3_SECRET']

def s3_connect
  Base.establish_connection!(
    :access_key_id     => settings.s3_key,
    :secret_access_key => settings.s3_secret
  )
end

get '/' do
  "You need to specify a project in the URL."
end

get '/success/' do
  p = session[:project]
  url = "http://client-preview.firebellydesign.com/#{p}/index.html"
  erb :success, :locals => { :p => p, :url => url }
end

get '/:project/' do
  s3_connect
  project = params[:project]
  
  begin
    b = Bucket.find(settings.bucket)
    pics = b.objects(:prefix => "#{project}/images/")
  rescue ResponseError => error
    halt "The images folder does not seem to exist."
  end
  images = []
  pics.each do |pic|
    image = File.basename("/#{pic.key()}")
    images << image if image != 'images'
  end
  
  erb :form, :locals => { :project => project, :images => images }
end

post '/:project/' do
  s3_connect
  
  project = params[:project]
  client = params[:client]
  images = params[:images]
  banner = params[:banner]
  style = params[:style]  
  
  template = File.read(File.join(File.dirname(__FILE__), 'templates', 'index.html.erb'))
  index = ERB.new(template)
  begin
    S3Object.store(
      "#{project}/index.html",
      index.result(binding),
      settings.bucket,
      :access => :public_read
    )
  rescue ResponseError => error
    halt "Could not setup the index file."
  end
  
  session[:project] = project
  redirect "/success/"
end