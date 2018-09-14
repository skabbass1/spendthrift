require 'aws-sdk-dynamodb'

module Spendthrift


  module DynamoDB


    DYNAMODB_TABLE_NAME = 'ExpenseReports'


    def self.load_report(report)

      dynamodb = Aws::DynamoDB::Client.new

      report.each do |key, value|
        params = {
            table_name: DYNAMODB_TABLE_NAME,
            item: {date: key, expenditure: value}
        }

        dynamodb.put_item(params)

      end

    end


  end

end
