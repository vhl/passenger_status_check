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
0 Passenger_8439 cpu=0|memory=264508|last_request_time=1440404826866466 Passenger pid 8439 cpu:0 memory:264508 last_request_time:1440404826866466
0 Passenger_8449 cpu=2|memory=439276|last_request_time=1440424552033587 Passenger pid 8449 cpu:2 memory:439276 last_request_time:1440424552033587
      TXT
      expect(@formatter.output).to eq(output)
    end
  end
end
