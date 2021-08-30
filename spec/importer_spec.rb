require 'spec_helper'

describe AwesomeModule::Importer do
  describe '#call' do
    let(:filter_date_from) { Date.parse('2020-01-01') }
    let(:filter_date_to) { Date.parse('2021-12-31') }
    let(:granularity) { 'by_date' }
    let(:order_dir) {}
    let(:file) { './data/bitcoin_json_test.json' }
    let(:params) { [filter_date_from, filter_date_to, granularity, order_dir] }

    subject { described_class.call(file, filter_date_from, filter_date_to, granularity) }

    describe 'filter by date' do
      context 'when all period was included' do
        it { expect(subject.size).to eq 9 }
      end

      context 'when all period was not included' do
        let(:filter_date_from) { Date.parse('2021-08-01') }
        let(:filter_date_to) { Date.parse('2021-08-31') }

        it { expect(subject.size).to eq 4 }
      end
    end

    describe 'sorting' do
      context 'default sorting' do
        it { expect(subject.last[0].to_s).to eq '2020-01-09' }
      end

      context 'asc sorting' do
        let(:order_dir) { 'asc' }
        subject { described_class.call(file, filter_date_from, filter_date_to, granularity, order_dir) }

        it { expect(subject.last[0].to_s).to eq '2021-12-08' }
      end
    end

    describe 'grouping' do
      # by_date by_week by_month by_quarter
      context 'by week' do
        let(:granularity) { 'by_week' }

        it do
          is_expected.to match_array([['49 2021', 7.0], ['35 2021', 3.5], ['34 2021', 1.0], ['27 2021', 3.0],
                                      ['50 2020', 6.0], ['2 2020', 1.0]])
        end
      end

      context 'by month' do
        let(:granularity) { 'by_month' }

        it do
          is_expected.to match_array([['12 2021', 7.0], ['8 2021', 2.25], ['7 2021', 3.0], ['12 2020', 6.0],
                                      ['1 2020', 1.0]])
        end
      end

      context 'by quarter' do
        let(:granularity) { 'by_quarter' }

        it do
          is_expected.to match_array([['4 2021', 7.0], ['3 2021', 2.5], ['4 2020', 6.0], ['1 2020', 1.0]])
        end
      end
    end
  end
end
