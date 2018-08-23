require 'plaid'
require 'date'

module Spendthrift
  module PlaidGateway

    class CredentialsError < StandardError;
    end
    class AccountAccessTokensError < StandardError;
    end

    class PlaidClient


      def initialize


        client_id, secret, public_key = load_credentials_from_env
        @client = Plaid::Client.new(env: :development,
                                    client_id: client_id,
                                    secret: secret,
                                    public_key: public_key)

        @access_tokens = load_access_tokens_from_env


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
        get_accounts_by_type 'credit', 'credit card'
      end


      def get_savings_accounts
        get_accounts_by_type 'depository', 'savings'
      end


      def get_checking_accounts
        get_accounts_by_type 'depository', 'checking'
      end


      private


      def load_credentials_from_env
        credentials = ENV['PLAID_CLIENT_ID'], ENV['PLAID_SECRET'], ENV['PLAID_PUBLIC_KEY']
        if credentials.any? {|c| c.nil?}
          raise CredentialsError.new(
              'PLAID_CLIENT_ID, PLAID_SECRET and PLAID_PUBLIC_KEY must be set as environment variables'
          )
        end

        credentials

      end


      def load_access_tokens_from_env
        if ENV.has_key? 'PLAID_ACCESS_TOKENS'
          puts ENV['PLAID_ACCESS_TOKENS']
          ENV['PLAID_ACCESS_TOKENS'].split ':'
        else
          raise AccountAccessTokensError.new(
              'Account access tokens must be set in the PLAID_ACCESS_TOKENS environment variable'
          )
        end
      end


      def get_accounts_by_type(type, subtype)
        @access_tokens.map do |token|
          response = @client.accounts.get token
          {
              access_token: token,
              accounts: response[:accounts].select {|account| account[:type] == type && account[:subtype] == subtype}
          }
        end
      end


    end

  end


end







