require_relative '../models/transaction_history.rb'
require_relative '../models/transaction.rb'
require_relative '../models/company.rb'
require File.expand_path '../spec_helper.rb', __FILE__

describe 'TransactionsApp' do
  it "should access the home page" do
    get '/'
    expect(last_response).to be_ok
  end
  context 'with an access token in the session' do
    it 'does not redirect to the index' do
      plaid_client = double('plaid client')
      allow(Plaid::Client).to receive(:new).and_return(plaid_client)
      allow(plaid_client).to receive_message_chain(:transactions, :get).with('access-sandbox-9dd5782d-be48-40d3-b676-1e2b13cd6b0c').and_return({})
      allow(I18n).to receive_message_chain(:config, :locales).and_return(:en)
      allow(Money).to receive_message_chain(:new, :format)
      env "rack.session", { access_token: "access-sandbox-9dd5782d-be48-40d3-b676-1e2b13cd6b0c" }
      get '/transactions'
      expect(last_request.url).to eql 'http://example.org/transactions'
    end
  end
  context 'without an access token in the session' do
    it 'redirects "transactions" to the index' do
      get '/transactions'
      expect(last_response).to be_redirect 
      follow_redirect!
      expect(last_request.url).to eql 'http://example.org/'
    end
  end
end
