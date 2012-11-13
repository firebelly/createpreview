require 'sinatra'
require 'rubygems'
require 'right_aws'

module RightAws
  class S3
    class Bucket
      def list(prefix, delimiter = '/')
        list = []
        @s3.interface.incrementally_list_bucket(@name, {'prefix' => prefix, 'delimiter' => delimiter}) do |item|
          list << item[:common_prefixes]
        end
        list.flatten.sort_by(&:downcase)
      end
    end
  end
end

enable :sessions

s3_config = YAML::load(File.open('config/s3.yml'))
 
s3 = RightAws::S3.new(s3_config['S3_KEY'], s3_config['S3_SECRET'])
$bucket = s3.bucket(s3_config['S3_BUCKET'])

def get_projects
  begin
    ignore_projects = ['example/', 'example-update/', 'createpreview/', 'test/']
    projects = $bucket.list("")
    projects = projects - ignore_projects
  rescue ResponseError => error
    halt "There are no projects."
  end
  return projects
end

get '/' do
  projects = get_projects
  erb :projects, :locals => { :projects => projects }
end

get '/success/' do
  p = session[:project]
  url = "http://client-preview.firebellydesign.com/#{p}/index.html"
  erb :success, :locals => { :p => p, :url => url }
end

get '/:project/' do
  project = params[:project]
  
  begin
    pics = $bucket.keys('prefix' => "#{project}/images/")
  rescue ResponseError => error
    halt "The images folder does not seem to exist."
  end
  
  if pics.length >= 1
    images = []
    pics.each do |pic|
      images << File.basename("/#{pic.full_name}") unless pic.full_name.end_with?('images/')
    end
  else
    halt "The images folder does not seem to exist or is empty.  Check the folder name (#{project}) and try again."
  end
  
  erb :form, :locals => { :project => project, :images => images }
end

post '/:project/' do  
  project = params[:project]
  client = params[:client]
  images = params[:images]
  banner = params[:banner]
  style = params[:style]  
  
  template = File.read(File.join(File.dirname(__FILE__), 'templates', 'index.html.erb'))
  index = ERB.new(template)
  begin
    key = $bucket.key("#{project}/index.html")
    key.put(index.result(binding), 'public-read')
  rescue RightAws::AwsError
    halt "Could not setup the index file."
  end
  
  key_data = open(File.join(File.dirname(__FILE__), 'templates', 'custom.css'))
  begin
    key2 = $bucket.key("#{project}/css/custom.css")
    key2.put(key_data, 'public-read')
  rescue RightAws::AwsError
    halt "Could not setup the custom css file."
  end
  
  session[:project] = project
  redirect "/success/"
end