require 'plaid'
require 'date'

module Spendthrift


  module PlaidGateway

    class VaultError < StandardError
    end


    class AccountTypeError < StandardError
    end

    class PlaidClient


      attr_reader :raw_client


      def initialize
          secrets  = load_secrets_from_vault
          @raw_client = Plaid::Client.new(env: :development,
                                          client_id: secrets[:PLAID_CLIENT_ID],
                                          secret: secrets[:PLAID_SECRET],
                                          public_key: secrets[:PLAID_PUBLIC_KEY])

          @access_tokens = secrets[:PLAID_ACCESS_TOKENS].split ':'

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
          raise AccountTypeError.new(
              "account type #{account_type} not known. Use one of ['credit', 'savings', 'checking']"
          )
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


      def load_secrets_from_vault
        secrets = (Spendthrift::Secrets.get_secrets)[:app]
        if secrets.nil?
          raise VaultError.new(
            'app secrets not found in vault'
          )
        end
        secrets
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

        # TODO: Need to add tests
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

        all_transactions

      end


    end


  end


end







