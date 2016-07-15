require 'spec_helper'
require 'passenger_status_check/formatters/dog_statsd'

describe PassengerStatusCheck::Formatters::DogStatsd do
  describe '#format' do
    let(:statsd) { double(Statsd).as_null_object }
    let(:data) { File.read('spec/fixtures/pass-status.xml') }
    let(:parser) { PassengerStatusCheck::Parser.new(data) }
    let(:thresholds) { { gqueue: 0, aqueue: 0, pcount: 2..2 } }
    let(:formatter) { described_class.new(parser, thresholds, tags: tags) }
    let(:tags) { ['testing'] }

    before do
      allow(statsd).to receive(:batch).and_yield(statsd)
      allow(Statsd).to receive(:new).and_return(statsd)
    end

    it 'sends global queue count metrics' do
      expect(statsd).to receive(:gauge).with('passenger.global_queue.count', 0, tags: tags)
      formatter.output
    end

    it 'sends application queue count metrics' do
      expect(statsd).to receive(:gauge).with('passenger.application_queue.count', 8, tags: tags)
      formatter.output
    end

    it 'sends passenger process count metrics' do
      expect(statsd).to receive(:gauge).with('passenger.processes.count', 2, tags: tags)
      formatter.output
    end

    it 'sends passenger workers stats' do
      (0..1).each do |process_id|
        expected_tags = tags + ["process_id:#{process_id}"]
        expect(statsd).to receive(:gauge).with("passenger.process.cpu", /\d/, tags: expected_tags)
        expect(statsd).to receive(:gauge).with("passenger.process.memory", /\d+/, tags: expected_tags)
        expect(statsd).to receive(:gauge).with("passenger.process.last_request_time", /\d+/, tags: expected_tags)
      end
      formatter.output
    end

    it 'sends passenger resisting deployment stats' do
      expect(statsd).to receive(:service_check).with('passenger.resisting_deployment_status', 0, message: 'Passenger resisting deployment OK')
      formatter.output
    end
  end
end
