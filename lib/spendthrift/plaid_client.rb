require 'plaid'
require 'date'

module Spendthrift


  module PlaidGateway

    class CredentialsError < StandardError
    end


    class AccountAccessTokensError < StandardError
    end

    class AccountTypeError < StandardError
    end

    class PlaidClient


      attr_reader :raw_client


      def initialize


        client_id, secret, public_key = load_credentials_from_env
        @raw_client = Plaid::Client.new(env: :development,
                                        client_id: client_id,
                                        secret: secret,
                                        public_key: public_key)

        @access_tokens = load_access_tokens_from_env

      end


      def get_account_transactions(start_date:, end_date:, account_type:)
        case account_type

        when :credit
          @accounts = get_credit_card_accounts
        when :checking
          @accounts = get_checking_accounts
        when :savings
          @accounts = get_savings_accounts

        else
          raise AccountTypeError.new("account type #{account_type} not known. Use one of ['credit', 'savings', 'checking']")
        end

        get_transactions start_date: start_date, end_date: end_date, accounts: @accounts

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
          ENV['PLAID_ACCESS_TOKENS'].split ':'
        else
          raise AccountAccessTokensError.new(
              'Account access tokens must be set in the PLAID_ACCESS_TOKENS environment variable'
          )
        end
      end


      def get_accounts_by_type(type, subtype)
        @access_tokens.map do |token|
          response = @raw_client.accounts.get token
          {
              access_token: token,
              accounts: response[:accounts].select {|account| account[:type] == type && account[:subtype] == subtype}
          }
        end
      end


      def get_transactions(start_date:, end_date:, accounts:)

        all_transactions = []

        accounts.each do |key_accounts_pair|

          account_ids = key_accounts_pair[:accounts].map {|account| account[:account_id]}

          transaction_response = @raw_client.transactions.get(key_accounts_pair[:access_token],
                                                              start_date,
                                                              end_date,
                                                              account_ids: account_ids)
          transactions = transaction_response.transactions

          while transactions.length < transaction_response['total_transactions']
            transaction_response = @raw_client.transactions.get(key_accounts_pair[:access_token],
                                                                start_date,
                                                                end_date,
                                                                account_ids: account_ids,
                                                                offset: transactions.length)
            transactions += transaction_response.transactions
          end
          all_transactions.concat transactions

        end

        sanitize all_transactions

      end


      def sanitize(transactions)
        transactions = remove_pending_transactions transactions
        remove_payments_and_refunds transactions
        remove_unneeded_attributes transactions
        combine_categories! transactions

      end


      def remove_pending_transactions(transactions)
        transactions.select {|t| !t[:pending]}
      end


      def remove_payments_and_refunds(transactions)
        transactions.select {|t| t[:amount] > 0}
      end


      def combine_categories!(transactions)
        transactions.each {|t| t[:category] = t[:category].join '-'}
      end


      def remove_unneeded_attributes(transactions)
        transactions.map {|t| {date: t[:date], amount: t[:amount], category: t[:category], vendor: t[:name]}}
      end


    end

  end


end







