require 'spec_helper'

describe PassengerStatusCheck::Parser do

  let(:status_check) do
    PassengerStatusCheck::Parser.new('spec/fixtures/pass-status.xml')
  end

  before(:each) do
    @parser = status_check
    status_check.parse
    @report = status_check.build_report
  end

  describe '#parse' do
    it 'loads the XML file' do
      expect(status_check.xml['version']).to eql('1.0')
    end
  end

  describe '#report' do
    it 'builds a report from the xml' do
      expect(@report.requests_in_top_level_queue).to eq('0')
      expect(@report.requests_in_queue).to eq('8')
    end

    context 'given a process' do
      before do
        @process = @report.processes.first
      end

      it 'reports the cpu usage' do
        expect(@process.cpu).to eq('0')
      end

      it 'reports the memory used' do
        expect(@process.memory).to eq('264508')
      end

      it 'reports the last request time' do
        expect(@process.last_request_time).to eq('1440404826866466')
      end
    end

    context 'given active processes' do
      it 'returns the number of processes' do
        expect(@parser.process_count).to eq(2)
      end
    end
  end
end
