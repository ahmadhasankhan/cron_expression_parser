# frozen_string_literal: true

require 'cron_parser'

describe CronParser do
  let(:valid_expression) { '*/15 0 1,15 * 1-5 /usr/bin/find' }
  let(:valid_expression2) { '15 1 1,15 3 1-5/2 /usr/bin/find' }
  let(:invalid_expression) { '0 1,15 * 1-5 /usr/bin/find' }
  let(:invalid_element) { 'a/15 0 1,15 * 1-5 /usr/bin/find' }

  subject { described_class.new(valid_expression) }

  describe '#initialize' do
    context 'when a valid expression was given' do
      it 'initializes the CronParser class' do
        expect(subject).to be_an_instance_of(CronParser)
      end

      it 'sets the cron expression' do
        expect(subject.instance_variable_get(:@expression)).to be(valid_expression)
      end
    end

    context 'when an invalid expression was given' do
      it 'raises an ArgumentError when incorrect number of fields' do
        expect { CronParser.new(invalid_expression) }.to raise_error(ArgumentError, 'incorrect number of fields')
      end

      it 'raises an ArgumentError when express in not an string' do
        expect { CronParser.new([valid_expression]) }.to raise_error(ArgumentError, 'not a valid expression')
      end
    end
  end

  describe '.display' do
    context 'when a valid expression was given' do
      it 'displays the result' do
        expect(subject.display).to include({ minute: [0, 15, 30, 45], hour: [0], dom: [1, 15],
                                             month: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], dow: [1, 2, 3, 4, 5],
                                             command: '/usr/bin/find' })
      end

      it 'displays the result of a different expression' do
        expect(CronParser.new(valid_expression2).display).to include({ minute: [15], hour: [1], dom: [1, 15],
                                                                       month: [3], dow: [1, 3, 5],
                                                                       command: '/usr/bin/find' })
      end
    end

    context 'when an invalid expression was given' do
      it 'raises an ArgumentError when element is invalid' do
        expect { CronParser.new(invalid_element).display }.to raise_error(ArgumentError)
      end
    end
  end
end
