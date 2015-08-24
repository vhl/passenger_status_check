require 'spec_helper'
require 'byebug'

describe PassengerStatusCheck::Parser do

  let(:status_check) do
    PassengerStatusCheck::Parser.new('spec/fixtures/pass-status.xml')
  end

  before(:each) do
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

    it 'reports the process information' do
      expect(@report.processes.first.memory).to eq('264508')
      expect(@report.processes.first.cpu).to eq('0')
      expect(@report.processes.first.last_time_request_handled).to eq('1440404826866466')
    end
  end
end
