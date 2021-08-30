require 'spec_helper.rb'

describe AwesomeModule::Caller do
  shared_examples 'raise StandardError' do
    it { expect { subject }.to raise_error(StandardError) }
  end

  shared_examples 'raise Date::Error' do
    it { expect { subject }.to raise_error(Date::Error) }
  end

  shared_examples 'Importer should be called' do
    it do
      expect(AwesomeModule::Importer).to receive(:call)
      subject
    end
  end


  let(:filter_date_from) { '2009-01-12' }
  let(:filter_date_to) { '2009-01-12' }
  let(:granularity) { 'by_week' }
  let(:order_dir) {}
  let(:params) { [filter_date_from, filter_date_to, granularity, order_dir] }

  subject { described_class.run params }

  describe '#run' do
    context 'if params is right' do
      it_behaves_like 'Importer should be called'
    end

    context 'if params has empty or wrong values' do
      context 'if filter_date_from is empty' do
        let(:filter_date_from) {}

        it_behaves_like 'raise StandardError'
      end

      context 'if filter_date_from is wrong' do
        let(:filter_date_from) { '45465' }

        it_behaves_like 'raise Date::Error'
      end

      context 'if filter_date_to is empty' do
        let(:filter_date_to) {}

        it_behaves_like 'raise StandardError'
      end

      context 'if filter_date_to is wrong' do
        let(:filter_date_to) { 'foo' }

        it_behaves_like 'raise Date::Error'
      end

      context 'if granularity is empty' do
        let(:granularity) {}

        it_behaves_like 'raise StandardError'
      end

      context 'if granularity is wrong' do
        let(:granularity) { 'foo' }

        it_behaves_like 'raise StandardError'
      end

      context 'if order_dir is empty' do
        let(:order_dir) {}

        it_behaves_like 'Importer should be called'
      end

      context 'if granularity is order_dir' do
        let(:order_dir) { 'foo' }

        it_behaves_like 'raise StandardError'
      end
    end
  end
end
