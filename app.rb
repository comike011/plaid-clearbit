require 'sinatra/base'
require 'plaid'
require 'clearbit'
require 'dotenv/load'
require 'sinatra/reloader'
require 'money'
require 'uri'

class TransactionsApp < Sinatra::Base
  enable :sessions
  configure :development do
    register Sinatra::Reloader
  end
  set :root, File.dirname(__FILE__)
  
  plaid_client = Plaid::Client.new(env: ENV['PLAID_ENV'],
                                   client_id: ENV['PLAID_CLIENT_ID'],
                                   secret: ENV['PLAID_SECRET_KEY'],
                                   public_key: ENV['PLAID_PUBLIC_KEY'])

  get '/' do
    erb :index, layout: :layout
  end

  get '/transactions' do
    redirect '/' if session[:access_token].nil?
    two_month_history = plaid_client.transactions.get(session[:access_token], (Date.today - 62), Date.today)
    @transaction_history = TransactionHistory.new(two_month_history['transactions'])
    erb :transactions, layout: :layout
  end

  post '/get_access_token' do
    exchange_token_response =
      plaid_client.item.public_token.exchange(params['public_token'])
    session[:access_token] = exchange_token_response['access_token']
    pretty_print_response(exchange_token_response)
    content_type :json
    exchange_token_response.to_json
  end

  def pretty_print_response(response)
    puts JSON.pretty_generate(response)
  end

end
