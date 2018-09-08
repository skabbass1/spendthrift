require 'aws-sdk'

module Spendthrift


  module DynamoDB


    DYNAMODB_TABLE_NAME = 'ExpenseReports'


    def self.load_report(report)
      Aws.config.update({
                            region: "us-west-2",
                            endpoint: "http://localhost:8000"
                        })

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