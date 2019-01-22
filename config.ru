require 'rubygems'
require 'bundler'
require 'pry'

Bundler.require
require File.dirname(__FILE__) + '/app'

Dir.glob('./models/*.rb').each { |file| require file }
I18n.config.available_locales = :en
Money.default_currency = Money::Currency.new("USD")

Clearbit.key = ENV['CLEARBIT_KEY']

run TransactionsApp
