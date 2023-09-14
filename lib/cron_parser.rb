# frozen_string_literal: true

require 'byebug'

class CronParser
  # matches in the followings order, digit one or more times, hyphen followed by digit/s, slash followed by digit/s
  CRON_ELEMENT_REGEX = %r{^(\d+)(-(\d+)(/(\d+))?)?$}

  def initialize(expression)
    @expression = expression
    validate_source
  end

  # Return the result
  def display
    # Split the cron expression elements
    tokens = @expression.split(/\s+/)

    {
      minute: parse_element(tokens[0], 0..59), # minute
      hour: parse_element(tokens[1], 0..23), # hour
      dom: parse_element(tokens[2], 1..31), # DOM
      month: parse_element(tokens[3], 1..12), # mon
      dow: parse_element(tokens[4], 0..6), # DOW
      command: tokens[5] # CMD
    }
  end

  private

  # Validate the cron expression
  def validate_source
    raise ArgumentError, 'not a valid expression' unless @expression.respond_to?(:split)

    return if @expression.split(/\s+/).length == 6

    raise ArgumentError, 'incorrect number of fields'
  end

  # Parse the cron expression elements
  def parse_element(elements, allowed_range)
    elements.split(',').map do |element|
      # If it contains * that means it has to repeat
      if element =~ /^\*/
        interval = element.length > 1 ? element[2..].to_i : 1
        interval_range(allowed_range, interval)
      else
        raise ArgumentError, "Bad cron expression element #{element}" unless CRON_ELEMENT_REGEX === element

        if ::Regexp.last_match(5) # with range
          interval_range(::Regexp.last_match(1).to_i..::Regexp.last_match(3).to_i, ::Regexp.last_match(5).to_i)
        elsif ::Regexp.last_match(3) # range without step
          interval_range(::Regexp.last_match(1).to_i..::Regexp.last_match(3).to_i, 1)
        else
          # return a numeric element
          [::Regexp.last_match(1).to_i]
        end

      end
    end.flatten.sort
  end

  def interval_range(range, interval = 1)
    len = range.last - range.first
    num = len.div(interval)
    result = (0..num).map { |i| range.first + interval * i }

    result.pop if (result[-1] == range.last) && range.exclude_end?
    result
  end
end
