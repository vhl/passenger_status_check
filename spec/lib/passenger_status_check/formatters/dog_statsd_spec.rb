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
      expect(statsd).to receive(:histogram).with('passenger.global_queue.count', 0, tags: tags)
      formatter.output
    end

    it 'sends application queue count metrics' do
      expect(statsd).to receive(:histogram).with('passenger.application_queue.count', 8, tags: tags)
      formatter.output
    end

    it 'sends passenger process count metrics' do
      expect(statsd).to receive(:histogram).with('passenger.processes.count', 2, tags: tags)
      formatter.output
    end

    it 'sends passenger workers stats' do
      expect(statsd).to receive(:histogram).with("passenger.process_0.cpu", '0', tags: tags)
      expect(statsd).to receive(:histogram).with("passenger.process_0.memory", '264508', tags: tags)
      expect(statsd).to receive(:histogram).with("passenger.process_0.last_request_time", '1440404826866466', tags: tags)
      expect(statsd).to receive(:histogram).with("passenger.process_1.cpu", '2', tags: tags)
      expect(statsd).to receive(:histogram).with("passenger.process_1.memory", '439276', tags: tags)
      expect(statsd).to receive(:histogram).with("passenger.process_1.last_request_time", '1440424552033587', tags: tags)
      formatter.output
    end

    it 'sends passenger resisting deployment stats' do
      expect(statsd).to receive(:event).with('passenger.resisting_deployment_status', 'OK', tags: tags)
      formatter.output
    end
  end
end
