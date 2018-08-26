require 'spec_helper'

describe Spendthrift::DataSanitize do


  before :context do
    @test_data = [
        {
            amount: -345,
            date: DateTime.new(2018, 8, 21),
            category: %w[Transfer Credit],
            pending: false,
            name: 'Automatic Payment',
            payment_meta: {},
            transaction_type: 'place',
            category_id: 1234,
            transaction_id: 1

        },

        {
            amount: 345,
            date: DateTime.new(2018, 8, 21),
            category: %w[Food Restaurants],
            pending: true,
            name: 'Cafe Awesome',
            payment_meta: {},
            transaction_type: 'place',
            category_id: 1235,
            transaction_id: 2
        },

        {
            amount: -345,
            date: DateTime.new(2018, 8, 21),
            category: %w[Shops],
            pending: false,
            name: 'Amazon',
            payment_meta: {},
            transaction_type: 'online',
            category_id: 1236,
            transaction_id: 3
        },

        {
            amount: 20,
            date: DateTime.new(2018, 8, 21),
            category: %w[Groceries],
            pending: false,
            name: 'Whole Foods',
            payment_meta: {},
            transaction_type: 'place',
            category_id: 1237,
            transaction_id: 4
        }

    ]
  end


  describe '.remove_pending_transactions' do


    it 'removes pending transactions' do
      transactions = Spendthrift::DataSanitize.remove_pending_transactions @test_data
      expect(transactions.select {|t| t[:pending]}).to be_empty

    end
  end


  describe '.remove_payments' do


    it 'removes negative amounts for credit card payments' do
      transactions = Spendthrift::DataSanitize.remove_payments @test_data
      expect(transactions.select {|t| t[:category].eql? %w[Transfer Credit]}).to be_empty

    end
  end


  describe '.join_categories!' do


    it 'joins categories in category hierarchy list into string' do
      transactions = Spendthrift::DataSanitize.join_categories! @test_data
      expect(transactions.select {|t| t[:category].kind_of? Array}).to be_empty
    end
  end


  describe '.select_attributes' do


    it 'returns the provided subset of attributes' do
      transactions = Spendthrift::DataSanitize.select_attributes @test_data,
                                                                 :transaction_id,
                                                                 :date,
                                                                 :amount,
                                                                 :category,
                                                                 :name
      transactions.each do |t|
        expect(t.keys).to contain_exactly :transaction_id,:date, :amount, :category, :name
      end
    end
  end

end