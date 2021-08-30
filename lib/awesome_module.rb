require 'pry'
require 'oj'
require 'active_support/time'

# example run $ruby ./lib/awesome_module.rb 2009-01-12 2020-12-12 by_date asc

module AwesomeModule
  module Importer
    module_function

    attr_reader :param

    def call(file_name, filter_date_from, filter_date_to, granularity, order_dir = 'desc')
      @arr = []
      @filter_date_from = filter_date_from
      @filter_date_to = filter_date_to

      read_file(file_name)

      @data = order_dir == 'asc' ? @arr.sort_by { |i| i[0] } : @arr.sort_by { |i| i[0] }.reverse

      res = case granularity
            when 'by_week'
              grouped(by_week)
            when 'by_month'
              grouped(by_month)
            when 'by_quarter'
              grouped(by_quarter)
            else
              @data
            end
      pp res
      res
    end

    def read_file(file_name)
      File.open(file_name) do |ff|
        nesting = 0
        str = +''

        until ff.eof?
          ch = ff.read(1)
          if ch == '{'
            nesting += 1
            str << ch
          elsif ch == '}'
            nesting -= 1
            str << ch
            if nesting.zero?
              record = Oj.load(str)
              import(record)
              str = +''
            end
          elsif nesting >= 1
            str << ch
          end
        end
      end
    end

    def import(record)
      date = Date.parse(record['date'])
      return unless date >= @filter_date_from && date <= @filter_date_to

      price = record['price(USD)'] || 0
      @arr << [date, price]
    end

    def grouped(data)
      data.map do |k, batch|
        [k, batch.map { |i| i[1].to_f }.reduce(:+) / batch.size]
      end
    end

    def by_date
      @data.group_by { |i| i[0] }
    end

    def by_week
      @data.group_by { |i| "#{i[0].cweek} #{i[0].year}" }
    end

    def by_month
      @data.group_by { |i| "#{i[0].month} #{i[0].year}" }
    end

    def by_quarter
      @data.group_by { |i| "#{(((i[0].month - 1) / 3) + 1).to_i} #{i[0].year}" }
    end
  end
end

module AwesomeModule
  module Caller
    module_function

    # rubocop:disable Layout/LineLength
    def input_help
      ' Input should be contains: filter_date_from filter_date_to granularity(should be include in [by_date by_week by_month by_quarter]) order_dir(optional, if present - should be include in [asc desc]'
    end
    # rubocop:enable Layout/LineLength

    def run(args)
      filter_date_from, filter_date_to, granularity, order_dir = args
      order_dir ||= 'desc'

      file_name = ENV['RACK_ENV'] == 'test' ? './data/bitcoin_json_test.json' : './data/bitcoin_json.json'

      raise StandardError, "#{file_name} should be exist! #{input_help}" unless File.file?(file_name)
      raise StandardError, "'Date from' should be provided! #{input_help}" unless filter_date_from
      raise StandardError, "'Date to' should be provided! #{input_help}" unless filter_date_to
      raise StandardError, "'Granularity' should be provided! #{input_help}" unless granularity
      raise StandardError, "Granularity is wrong! #{input_help}" unless %w[by_date by_week by_month by_quarter]
                                                                        .include?(granularity)
      raise StandardError, "Order is wrong!  #{input_help}" unless %w[desc asc].include?(order_dir)

      Importer.call(file_name,
                    Date.parse(filter_date_from),
                    Date.parse(filter_date_to),
                    granularity,
                    order_dir)
    end
  end
end

AwesomeModule::Caller.run(ARGV) unless ENV['RACK_ENV'] == 'test'
