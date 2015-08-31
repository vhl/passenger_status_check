require 'spec_helper'

describe PassengerStatusCheck::Process do
  context 'given a xml fragment with process info' do
    before do
      xml = Ox.parse(File.read('spec/fixtures/pass-status.xml'))
      @process_xml = xml.locate('info/supergroups/supergroup/group/processes/process/').first
      @process = PassengerStatusCheck::Process.new(@process_xml)
    end

    it 'exposes the PID' do
      expect(@process.pid).to eql('8439')
    end

    it 'exposes cpu info' do
      expect(@process.cpu).to eql('0')
    end

    it 'exposes memory usage' do
      expect(@process.memory).to eql('264508')
    end

    it 'exposes the last time the process handled a request' do
      expect(@process.last_request_time).to eql('1440404826866466')
    end
  end
end
