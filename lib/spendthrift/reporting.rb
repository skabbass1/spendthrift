module Spendthrift


  module Reporting


    def self.spending_per_month_by_category(transactions)

      by_year_month = group_by_year_month transactions

      by_year_month.transform_values do |v|

        by_category = v.group_by {|t| t[:category]}
        by_category.transform_values do |v|
          v.map {|t| t[:amount]}.reduce :+

        end
      end

    end


    def self.convert_list_keys_to_string(report)
      Hash[report.map {|k, v| [k.join, v]}]
    end

    def self.group_by_year_month(transactions)
      transactions.group_by do |t|
        date = Date.parse t[:date]
        [date.year, date.month]
      end
    end


    private_class_method :group_by_year_month
  end
end
