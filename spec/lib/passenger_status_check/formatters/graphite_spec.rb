require 'spec_helper'
require 'passenger_status_check/formatters/graphite'

describe PassengerStatusCheck::Formatters::Graphite do

  describe '#format' do
    before() do
      @thresholds = { gqueue: 0, aqueue: 0, pcount: 2..2 }
      data = File.read('spec/fixtures/pass-status.xml')
      @parser = PassengerStatusCheck::Parser.new(data)
      @formatter = PassengerStatusCheck::Formatters::Graphite.new(@parser, @thresholds)
    end

    describe '#global_queue' do
      it 'generates output in the expected graphite format' do
        output = "passenger.global.queue.count 0 #{Time.now.to_i}"
        expect(@formatter.output).to eq(output)
      end
    end

    describe '#application_queue' do
      it 'generates the application queue for graphite consumption' do
        output = "passenger.application.queue.count 8 #{Time.now.to_i}"
        expect(@formatter.application_queue).to eq(output)
      end
    end

    describe '#passenger_processes' do
      it 'generates passenger process count for graphite consumption' do
        output = "passenger.processes.count 2 #{Time.now.to_i}"
        expect(@formatter.passenger_processes).to eq(output)
      end
    end

    describe '#global_queue_requests' do
      it 'gets the global queue requests from the parser' do
        expect(@parser).to receive(:requests_in_top_level_queue)
        @formatter.global_queue_requests
      end
    end

    describe '#application_queue_requests' do
      it 'gets the application queue requests from the parser' do
        expect(@parser).to receive(:requests_in_app_queue)
        @formatter.application_queue_requests
      end
    end

    describe '#process_count' do
      it 'gets the process count from the parser' do
        expect(@parser).to receive(:process_count)
        @formatter.process_count
      end
    end
  end
end
