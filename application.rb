require 'sinatra/base'
require 'sinatra/assetpack'
require 'haml'
require 'sass'
require 'httparty'
require 'json'
require 'pony'
require 'i18n'


I18n.load_path += Dir[File.join(File.dirname(__FILE__), 'config', 'locales', '*.yml').to_s]

class Application < Sinatra::Base
  set :root, File.dirname(__FILE__)
  set :sass, { :load_paths => [ "#{Application.root}/assets/stylesheets" ] }
  set :protection, :except => :frame_options

  register Sinatra::AssetPack

  assets {
    serve '/css', from: 'assets/stylesheets'
    serve '/images', from: 'assets/images'
    serve '/js', from: 'assets/javascripts'
    serve '/fonts', from: 'assets/fonts'

    css :application, '/css/application.css', %w(/css/reset.css /css/index.css)
    js :application, '/js/application.js', %w( /js/jquery-1.9.1.js /js/initializer.js /js/form.js)

    css_compression :sass
    js_compression :jsmin
  }

  get '/' do
    haml :index
  end

  get '/webinar' do
    haml :webinar
  end

  post '/orders.json' do

    message = "#{params[:order][:name]}. #{params[:order][:phone]}. #{params[:order][:email]}"

    #if params[:order][:message]
    #  message += "\n\n"
    #  message += "#{params[:order][:message]}"
    #end

    Pony.mail ({
        to: 'abardacha@gmail.com',
        subject: I18n.t('email.title', locale: 'ru'),
        html_body: (haml :mail, layout: false),
        via: :smtp,
        via_options: {
            address: 'smtp.gmail.com',
            port: 587,
            enable_starttls_auto: true,
            user_name: 'abardacha@gmail.com',
            password: 'fiolent149',
            authentication: :plain
        }
    })

    content_type :json
    {status: :success}.to_json
  end
end