require 'spec_helper'
require_relative '../../models/transaction.rb'
require_relative '../../models/company.rb'

describe Transaction do
  let(:name) { 'Company Name' }
  let(:date) { '2019-01-20' }
  let(:category) { ['food'] }
  let(:amount) { '10' }
  let(:transaction_hash) { {name: name, date: date, category: Array(category), amount: amount} }
  let(:transaction) { Transaction.new(transaction_hash) }

  describe '#initialize' do
    context 'when all values are present in received hash' do
      before(:each) do
        allow(Company).to receive(:new)
      end
      it 'assigns amount from hash' do
        expect(transaction.amount).to eq(amount)
      end
      it 'assigns name from hash' do
        expect(transaction.name).to eq(name)
      end
      it 'assigns date from hash' do
        expect(transaction.date).to eq(date)
      end
      it 'assigns category from hash' do
        expect(transaction.category).to eq(category.first)
      end
      context 'and there are three transactions with the same amount and name' do
        before do
          @transaction_history = Array.new(3){ |i| { name: name, date: (Date.today - (30 * i)), amount: amount, category: category } }
        end
        it 'assigns frequency as the number of matching records' do
          transaction = Transaction.new(transaction_hash, @transaction_history)
          expect(transaction.frequency).to eq(3)
        end
      end
      context 'and there are two transactions with the same name but not same amount' do
        before do
          @transaction_history = Array.new(2){ |i| { name: name, date: (Date.today - (30 * i)), amount: (amount * (i+1)), category: category } }
        end
        it 'assigns frequency as 1' do
          transaction = Transaction.new(transaction_hash, @transaction_history)
          expect(transaction.frequency).to eq(1)
        end
      end
      it 'assigns company to a new company object' do
        expect(Company).to receive(:new)
        Transaction.new(transaction_hash)
      end
      context 'and there are previous similar transactions' do
        it 'assigns previous atrributes of the next most recent transaction' do
          transaction_history = Array.new(3){ |i| { name: name, date: (Date.today - (30 * i)), amount: amount, category: category } }
          transaction = Transaction.new(transaction_hash, transaction_history)
          expect(transaction.previous_attributes).to eq({amount: amount, date: (Date.today - 30), name: name})
        end
      end
      context 'and there are no previous similar transactions' do
        it 'assings previous attributes to an empty string' do
          transaction_history = Array.new(2){ |i| { name: name, date: (Date.today - (30 * i)), amount: (amount * (i+1)), category: category } }
          transaction = Transaction.new(transaction_hash, transaction_history)
          expect(transaction.previous_attributes).to eq({})
        end
      end
    end
  end
  describe '#recurring' do
    context 'when frequency is above 2' do
      it 'is true' do
        transaction_history = Array.new(3){ |i| { name: name, date: (Date.today - (30 * i)), amount: amount, category: category } }
        transaction = Transaction.new(transaction_hash, transaction_history)
        expect(transaction.recurring?).to eq(true)
      end
    end
    context 'when frequency is 2' do
      it 'is false' do
        transaction_history = Array.new(2){ |i| { name: name, date: (Date.today - (30 * i)), amount: (amount * (i+1)), category: category } }
        transaction = Transaction.new(transaction_hash, transaction_history)
        expect(transaction.recurring?).to eq(false)
      end
    end
  end
  describe 'delegators' do
    before(:each) do
      @company = double('company')
      allow(Company).to receive(:new).and_return(@company)
      transaction = Transaction.new(transaction_hash)
    end
    it 'delegates domain to company' do
      expect(@company).to receive(:name)
      transaction.company_name
    end
    it 'delegates logo to company' do
      expect(@company).to receive(:logo)
      transaction.company_logo
    end
    it 'delegates name to company' do
      expect(@company).to receive(:name)
      transaction.company_name
    end
    it 'delegates description to company' do
      expect(@company).to receive(:description)
      transaction.company_description
    end
  end
end
