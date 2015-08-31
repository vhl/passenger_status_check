require 'spec_helper'
require 'passenger_status_check/checks/passenger_check'

describe PassengerStatusCheck::Checks::PassengerCheck do
  before do
    thresholds = { gqueue: 0, aqueue: 0, pcount: 2..2 }
    @parser = PassengerStatusCheck::Parser.new('spec/fixtures/pass-status.xml')
    @passenger_check = PassengerStatusCheck::Checks::PassengerCheck.new(@parser, thresholds)
  end

  describe '#global_queue_check' do
    context 'when the values match' do
      it 'returns an OK status' do
        allow(@parser).to receive(:requests_in_top_level_queue) { 0 }
        expect(@passenger_check.global_queue_check).to eq(0)
      end
    end

    context 'when the values do not match' do
      it 'returns a critical status' do
        allow(@parser).to receive(:requests_in_top_level_queue) { 1 }
        expect(@passenger_check.global_queue_check).to eq(2)
      end
    end
  end

  describe '#app_queue_check' do
    context 'when the values match' do
      it 'returns an OK status' do
        allow(@parser).to receive(:requests_in_app_queue) { 0 }
        expect(@passenger_check.app_queue_check).to eq(0)
      end
    end

    context 'when the values do not match' do
      it 'returns a critical status' do
        allow(@parser).to receive(:requests_in_app_queue) { 100 }
        expect(@passenger_check.app_queue_check).to eq(2)
      end
    end
  end

  describe '#process_count_check' do
    context 'when the values are in a certain range' do
      it 'returns an OK status' do
        allow(@parser).to receive(:process_count) { 2 }
        expect(@passenger_check.process_count_check).to eq(0)
      end
    end

    context 'when the values are below the range' do
      it 'returns a critical status' do
        allow(@parser).to receive(:process_count) { 1 }
        expect(@passenger_check.process_count_check).to eq(2)
      end
    end

    context 'when the values are below the range' do
      it 'returns a critical status' do
        allow(@parser).to receive(:process_count) { 3 }
        expect(@passenger_check.process_count_check).to eq(2)
      end
    end
  end
end
