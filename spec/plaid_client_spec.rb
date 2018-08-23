require 'spec_helper'

RSpec.describe Spendthrift::PlaidGateway::PlaidClient do
  describe '#new' do
    before :each do
      @client_id = ENV.delete 'PLAID_CLIENT_ID'
      @secret = ENV.delete 'PLAID_SECRET'
      @public_key = ENV.delete 'PLAID_PUBLIC_KEY'
      @access_tokens = ENV.delete 'PLAID_ACCESS_TOKENS'
      ENV['PLAID_ACCESS_TOKENS'] = 'test'
    end


    context 'when client instantiated without valid credentials in environment' do
      it 'raises CredentialsError' do
        expect {Spendthrift::PlaidGateway::PlaidClient.new}
            .to raise_error Spendthrift::PlaidGateway::CredentialsError
      end
    end


    after :each do
      ENV['PLAID_CLIENT_ID'] = @client_id
      ENV['PLAID_SECRET'] = @secret
      ENV['PLAID_PUBLIC_KEY'] = @public_key
      ENV['PLAID_ACCESS_TOKENS'] = @access_tokens
    end
  end

  describe '#new' do
    before :each do
      @client_id = ENV.delete 'PLAID_CLIENT_ID'
      @secret = ENV.delete 'PLAID_SECRET'
      @public_key = ENV.delete 'PLAID_PUBLIC_KEY'
      @access_tokens = ENV.delete 'PLAID_ACCESS_TOKENS'

      ENV['PLAID_CLIENT_ID'] = 'test'
      ENV['PLAID_SECRET'] = 'test'
      ENV['PLAID_PUBLIC_KEY'] = 'test'
    end


    context 'when client instantiated without access tokens in environment' do
      it 'raises AccountAccessTokensError' do
        expect {Spendthrift::PlaidGateway::PlaidClient.new}
            .to raise_error Spendthrift::PlaidGateway::AccountAccessTokensError
      end
    end


    after :each do
      ENV['PLAID_CLIENT_ID'] = @client_id
      ENV['PLAID_SECRET'] = @secret
      ENV['PLAID_PUBLIC_KEY'] = @public_key
      ENV['PLAID_ACCESS_TOKENS'] = @access_tokens

    end
  end


  describe '#get_credit_card_accounts' do
    before :each do
      @access_tokens = ENV.delete 'PLAID_ACCESS_TOKENS'
      ENV['PLAID_ACCESS_TOKENS'] = 'test'
    end


    it 'only returns credit card accounts' do

      test_data = {
          accounts: [{
                         account_id: '123',
                         type: 'credit',
                         subtype: 'credit card'
                     },

                     {
                         account_id: '456',
                         type: 'depository',
                         subtype: 'savings'
                     },
                     {
                         account_id: '789',
                         type: 'depository',
                         subtype: 'checking'
                     },
          ]
      }

      allow_any_instance_of(Plaid::Accounts).to receive(:get).and_return(test_data)
      client = Spendthrift::PlaidGateway::PlaidClient.new
      accounts = client.get_credit_card_accounts

      expect(accounts.length).to eq 1
      expect(accounts.first[:accounts].first[:account_id]).to eq '123'
    end


    after :each do
      ENV['PLAID_ACCESS_TOKENS'] = @access_tokens
    end
  end


end
