require 'spec_helper'

RSpec.describe Spendthrift::PlaidGateway::PlaidClient do
  describe '#new' do
    before :each do
      @client_id = ENV.delete 'PLAID_CLIENT_ID'
      @secret = ENV.delete 'PLAID_SECRET'
      @public_key = ENV.delete 'PLAID_PUBLIC_KEY'


    end
    context 'when client instantiated without valid credentials in environment' do
      it 'raises MissingPlaidCredentialsError' do
        expect {Spendthrift::PlaidGateway::PlaidClient.new}
            .to raise_error(
                    Spendthrift::PlaidGateway::MissingPlaidCredentialsError
                )
      end
    end

    after :each do
      ENV['PLAID_CLIENT_ID'] = @client_id
      ENV['PLAID_SECRET'] = @secret
      ENV['PLAID_PUBLIC_KEY'] = @public_key

    end
  end
end
