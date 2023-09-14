# frozen_string_literal: true

require './lib/cron_parser'

puts 'Please enter your cron expression'
exp = gets.chomp
cp = CronParser.new(exp).display

puts "minute         #{cp[:minute].join(' ')}" # minute
puts "hour           #{cp[:hour].join(' ')}" # hour
puts "day of month   #{cp[:dom].join(' ')}" # DOM
puts "month          #{cp[:month].join(' ')}" # mon
puts "day of week    #{cp[:dow].join(' ')}" # DOW
puts "command        #{cp[:command]}" # CMD
