require 'spec_helper'

describe PassengerStatusCheck::Parser do

  before(:each) do
    @parser = PassengerStatusCheck::Parser.new('spec/fixtures/pass-status.xml')
  end

  describe '#parse' do
    it 'loads the XML file' do
      expect(@parser.xml['version']).to eql('1.0')
    end
  end

  describe '#process_count' do
    it 'returns the number of active processes' do
      expect(@parser.process_count).to eq(2)
    end
  end

  describe '#requests_in_top_level_queue' do
    it 'returns the number of requests in the global queue' do
      expect(@parser.requests_in_top_level_queue).to eq('0')
    end
  end

  describe '#requests_in_app_queue' do
    it 'returns the number of requests backed up in the app queue' do
      expect(@parser.requests_in_app_queue).to eq('8')
    end
  end


  describe '#processes' do
    it 'contains the correct number of processes' do
      expect(@parser.processes.size).to eq(2)
    end

    context 'given a process' do
      before do
        @process = @parser.processes.first
      end

      it 'reports the pid' do
        expect(@process.pid).to eql('8439')
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
  end
end
