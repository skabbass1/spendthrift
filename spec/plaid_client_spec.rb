require 'spec_helper'


RSpec.describe Spendthrift::PlaidGateway::PlaidClient do


  describe '#new' do
    before :example do
      clear_env
    end


    context 'when client instantiated with access tokens but no login credentials' do
      it 'raises CredentialsError' do

        ENV['PLAID_ACCESS_TOKENS'] = 'test'

        expect {Spendthrift::PlaidGateway::PlaidClient.new}
            .to raise_error Spendthrift::PlaidGateway::CredentialsError
      end
    end


    context 'when client instantiated with credentials but without access tokens' do
      it 'raises AccountAccessTokensError' do

        ENV['PLAID_CLIENT_ID'] = 'test'
        ENV['PLAID_SECRET'] = 'test'
        ENV['PLAID_PUBLIC_KEY'] = 'test'

        expect {Spendthrift::PlaidGateway::PlaidClient.new}
            .to raise_error Spendthrift::PlaidGateway::AccountAccessTokensError
      end
    end


    after :example do
      restore_env
    end
  end


  describe '#get_credit_card_accounts' do


    before :example do
      clear_env
      prepare_env
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
      restore_env
    end
  end


  describe '#get_savings_accounts' do


    before :each do
      clear_env
      prepare_env
    end


    it 'only returns savings accounts' do

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
      accounts = client.get_savings_accounts

      expect(accounts.length).to eq 1
      expect(accounts.first[:accounts].first[:account_id]).to eq '456'
    end


    after :each do
      restore_env
    end
  end

  describe '#get_checking_accounts' do


    before :each do
      clear_env
      prepare_env
    end


    it 'only returns checking accounts' do

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
      accounts = client.get_checking_accounts

      expect(accounts.length).to eq 1
      expect(accounts.first[:accounts].first[:account_id]).to eq '789'
    end


    after :each do
      ENV['PLAID_ACCESS_TOKENS'] = @access_tokens
    end
  end


  def prepare_env
    ENV['PLAID_CLIENT_ID'] = 'test'
    ENV['PLAID_SECRET'] = 'test'
    ENV['PLAID_PUBLIC_KEY'] = 'test'
    ENV['PLAID_ACCESS_TOKENS'] = 'test'
  end


  def clear_env
    ENV['keep_PLAID_CLIENT_ID'] = ENV.delete 'PLAID_CLIENT_ID'
    ENV['keep_PLAID_SECRET'] = ENV.delete 'PLAID_SECRET'
    ENV['keep_PLAID_PUBLIC_KEY'] = ENV.delete 'PLAID_PUBLIC_KEY'
    ENV['keep_PLAID_ACCESS_TOKENS'] = ENV.delete 'PLAID_ACCESS_TOKENS'

  end


  def restore_env
    ENV['PLAID_CLIENT_ID'] = ENV['keep_PLAID_CLIENT_ID']
    ENV['PLAID_SECRET'] = ENV['keep_PLAID_SECRET']
    ENV['PLAID_PUBLIC_KEY'] = ENV['keep_PLAID_PUBLIC_KEY']
    ENV['PLAID_ACCESS_TOKENS'] = ENV['keep_PLAID_ACCESS_TOKENS']

    ENV.delete 'keep_PLAID_CLIENT_ID'
    ENV.delete 'keep_PLAID_SECRET'
    ENV.delete 'keep_PLAID_PUBLIC_KEY'
    ENV.delete 'keep_PLAID_ACCESS_TOKENS'
  end


end
