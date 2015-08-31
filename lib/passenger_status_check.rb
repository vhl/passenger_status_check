require 'ox'
require "passenger_status_check/version"
require 'passenger_status_check/parser'
require 'passenger_status_check/formatters/check_mk'
require 'passenger_status_check/formatters/graphite'

module PassengerStatusCheck

  def self.run(formatter_name, thresholds, data)
    parser = PassengerStatusCheck::Parser.new(data)
    formatter = formatter_class(formatter_name).new(parser, thresholds)
    formatter.output
  end

  def self.formatter_class(formatter)
    klass = formatter.to_s.split('_').map(&:capitalize).join
    const_get("PassengerStatusCheck::Formatters::#{klass}")
  end
end
