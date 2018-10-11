require 'spec_helper'


RSpec.describe Spendthrift::PlaidGateway::PlaidClient do

  def stub_vault
    allow(Spendthrift::Secrets).to receive(:get_secrets) {
      {
        app: {
          PLAID_CLIENT_ID: 'test',
          PLAID_SECRET: 'test',
          PLAID_PUBLIC_KEY: 'test',
          PLAID_ACCESS_TOKENS: 'test'
        }
      }
    }
  end

  describe '#new' do
    context 'when client cannot access secrets' do
      it 'raises' do
        allow(Spendthrift::Secrets).to receive(:get_secrets) {{app: nil}}
        expect {Spendthrift::PlaidGateway::PlaidClient.new}
          .to raise_error "app secrets not found in vault"
      end
    end
  end

  describe '#get_credit_card_accounts' do
    it 'only returns credit card accounts' do
      stub_vault
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
  end


  describe '#get_savings_accounts' do

    it 'only returns savings accounts' do
      stub_vault
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

  end

  describe '#get_checking_accounts' do

    it 'only returns checking accounts' do
      stub_vault
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
  end
end
