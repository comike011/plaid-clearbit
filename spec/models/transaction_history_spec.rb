require 'spec_helper'
require 'faker'
require_relative '../../models/transaction_history.rb'
require_relative '../../models/transaction.rb'

describe TransactionHistory do
  describe '#initialize' do
    it 'takes an array of transactions and assigns the first 10 to transactions as objects' do
      transaction_history = Array.new(30){ |i| { name: Faker::Company.name, amount: [10..100].sample(1), category: Faker::Lorem.words(4), date: Date.today } }
      transaction_history = TransactionHistory.new(transaction_history)
      expect(transaction_history.transactions.size).to eq(10)
      transaction_history.transactions.each do |t|
        expect(t.class).to eq(Transaction)
      end
    end
  end
end

