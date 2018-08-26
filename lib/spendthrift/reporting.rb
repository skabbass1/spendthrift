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


    private


    def self.group_by_year_month(transactions)
      transactions.group_by do |t|
        date = Date.parse t[:date]
        [date.year, date.month]
      end
    end
  end
end


# #def total_expenses_by_month(transactions)
# grouped = transactions.group_by do |t|
#   date = Date.parse(t['date'])
#   [date.year, date.month]
# end
#
# grouped.each do |date, t|
#   total = t.map{|item| item['amount'] < 0 ? 0 :item['amount']}.reduce(:+)
#   puts "date=#{date}  total=#{total}"
#
#   category_group=t.group_by do |g|
#     g['category']
#   end
#
#   category_group.each do |category, t|
#     total = t.map{|item| item['amount'] < 0 ? 0 :item['amount']}.reduce(:+)
#     puts "category=#{category}  total=#{total}"
#   end
#
# end
#
#
# end
# #
#
#
#
#
#
#
#