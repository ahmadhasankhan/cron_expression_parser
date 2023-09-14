# Cron Expression Parser

## Installation

### Prerequisite
Make sure you have ruby version 3.2.2 installed

`$ bundle install`

It will install the dependecy gems

## Run the code
Go inside the root of project directory and run

`$ ruby run.rb`

It ill prompt you to enter your cron expression,

Type `*/15 0 1,15 * 1-5 /usr/bin/find` and you will see the below output on the console

```
minute         0 15 30 45
hour           0
day of month   1 15
month          1 2 3 4 5 6 7 8 9 10 11 12
day of week    1 2 3 4 5
command        /usr/bin/find

```

## Test
`$ bundle exec rspec`

### Test coverage

<img width="1792" alt="Screenshot 2023-09-14 at 11 06 09 AM" src="https://github.com/ahmadhasankhan/cron_expression_parser/assets/3341200/9ef3541b-ddc7-4793-a3ae-4b71d1a827cc">
