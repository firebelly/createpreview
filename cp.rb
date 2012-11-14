require 'sinatra'
require 'rubygems'
require 'aws-sdk'

enable :sessions

helpers do
  def protected!
    unless session[:logged_in]
      if authorized?
        session[:logged_in] = true
      else
        response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
        throw(:halt, [401, "Not authorized\n"])
      end
    end
  end

  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == ['admin', 'admin']
  end
end

s3_config = YAML::load(File.open('config/s3.yml'))

AWS.config(
  :access_key_id => s3_config['S3_KEY'],
  :secret_access_key => s3_config['S3_SECRET']
)
 
s3 = AWS::S3.new
$bucket = s3.buckets[s3_config['S3_BUCKET']]

def get_projects
  begin
    ignore_projects = ["example/", "example-update/", "createpreview/", "test/"]
    project_tree = $bucket.objects.as_tree
    projects = project_tree.children.select(&:branch?).collect(&:prefix).sort_by(&:downcase) - ignore_projects
  rescue AWS::Errors
    halt "There are no projects."
  end
  return projects
end

get '/' do
  projects = get_projects
  erb :projects, :locals => { :projects => projects }
end

get '/success/' do
  protected!
  p = session[:project]
  url = "http://client-preview.firebellydesign.com/#{p}/index.html"
  erb :success, :locals => { :p => p, :url => url }
end

get '/:project/' do
  protected!
  project = params[:project]
  
  begin
    pics = $bucket.objects.with_prefix("#{project}/images/").collect(&:key)
  rescue ResponseError => error
    halt "The images folder does not seem to exist."
  end
  
  if pics.length >= 1
    images = []
    pics.each do |pic|
      images << File.basename("/#{pic}") unless pic.end_with?('images/')
    end
  else
    halt "The images folder does not seem to exist or is empty.  Check the folder name (#{project}) and try again."
  end
  
  erb :form, :locals => { :project => project, :images => images }
end

post '/:project/' do
  protected!
  project = params[:project]
  client = params[:client]
  images = params[:images]
  banner = params[:banner]
  style = params[:style]
  user = params[:user]
  pass = params[:password]
  
  template = File.read(File.join(File.dirname(__FILE__), 'templates', 'index.html.erb'))
  index = ERB.new(template)
  begin
    $bucket.objects["#{project}/index.html"].write(index.result(binding))
  rescue AWS::Errors
    halt "Could not setup the index file."
  end
  
  begin
    $bucket.objects["#{project}/css/custom.css"].write(open(File.join(File.dirname(__FILE__), 'templates', 'custom.css')))
  rescue AWS::Errors
    halt "Could not setup the custom css file."
  end

  template = File.read(File.join(File.dirname(__FILE__), 'templates', 'main_index.html.erb'))
  index = ERB.new(template)
  @projects = get_projects
  begin
    $bucket.objects["index.html"].write(index.result(binding))
  rescue AWS::Errors
    halt "Could not setup the custom css file."
  end
  
  session[:project] = project
  redirect "/success/"
end