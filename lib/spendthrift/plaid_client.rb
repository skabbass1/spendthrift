require 'plaid'
require 'date'

module PlaidGateway

  class PlaidClient
    def initialize
      @client = Plaid::Client.new(env: :development,
                                  client_id: ENV['PLAID_CLIENT_ID'],
                                  secret: ENV['PLAID_SECRET'],
                                  public_key: ENV['PLAID_PUBLIC_KEY'])

      @access_tokens = ENV['PLAID_ACCESS_TOKENS'].split ':'


    end

    def get_all_transactions(start_date:, end_date:)

      all_transactions = []
      credit_card_accounts = get_credit_card_accounts

      credit_card_accounts.each do |key_accounts_pair|

        account_ids = key_accounts_pair[:accounts].map {|account| account[:account_id]}

        transaction_response = @client.transactions.get(key_accounts_pair[:access_token],
                                                        start_date,
                                                        end_date,
                                                        account_ids: account_ids)
        transactions = transaction_response.transactions

        while transactions.length < transaction_response['total_transactions']
          transaction_response = @client.transactions.get(key_accounts_pair[:access_token],
                                                          start_date,
                                                          end_date,
                                                          account_ids: account_ids,
                                                          offset: transactions.length)
          transactions += transaction_response.transactions
        end
        all_transactions.concat transactions

      end

      all_transactions

    end

    def get_credit_card_accounts
      get_accounts_by_type 'credit'
    end


    def get_accounts_by_type(type)
      @access_tokens.map do |token|
        response = @client.accounts.get token
        {access_token: token, accounts: response[:accounts].select {|account| account[:type] == type}}
      end
    end

  end

end







