require 'spec_helper'

describe PassengerStatusCheck do
  it 'has a version number' do
    expect(PassengerStatusCheck::VERSION).not_to be nil
  end


  describe '.run' do
    before do
      file_path = 'spec/fixtures/pass-status.xml'
      @data = File.read(file_path)
    end

    it 'generates output compatible with the specified agent' do

      expected = <<-TXT
0 Global_queue count=0 Global queue: 0
2 Application_queue count=8 Application queue: 8
0 Passenger_processes count=2 Passenger processes: 2
0 Passenger_8439 cpu=0|memory=264508|last_request_time=1440404826866466 Passenger pid 8439 cpu:0 memory:264508 last_request_time:1440404826866466
0 Passenger_8449 cpu=2|memory=439276|last_request_time=1440424552033587 Passenger pid 8449 cpu:2 memory:439276 last_request_time:1440424552033587
      TXT

      formatter  = :check_mk
      thresholds = { gqueue: 0, aqueue: 0, pcount: 2..2 }

      output = PassengerStatusCheck.run(formatter, thresholds, @data)

      expect(output).to match(expected)
    end
  end
end
