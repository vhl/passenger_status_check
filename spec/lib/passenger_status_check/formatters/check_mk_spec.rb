require 'spec_helper'
require 'passenger_status_check/formatters/check_mk'

describe PassengerStatusCheck::Formatters::CheckMk do

  describe '#format' do
    before(:each) do
      @thresholds = { gqueue: 0, aqueue: 0, pcount: 2..2 }
      data = File.read('spec/fixtures/pass-status.xml')
      @parser = PassengerStatusCheck::Parser.new(data)
      @formatter = PassengerStatusCheck::Formatters::CheckMk.new(@parser, @thresholds)
    end

    it 'generates output in the expected check_mk format' do
      output = <<-TXT
0 Global_queue count=0 Global queue: 0
2 Application_queue count=8 Application queue: 8
0 Passenger_processes count=2 Passenger processes: 2
0 Passenger_workers p0_cpu=0|p0_memory=264508|p0_last_request_time=1440404826866466|p1_cpu=2|p1_memory=439276|p1_last_request_time=1440424552033587
      TXT
      expect(@formatter.output).to eq(output)
    end
  end
end
