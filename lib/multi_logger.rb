# frozen_string_literal: true

class MultiLogger
  def initialize(*loggers)
    @loggers = loggers
  end

  def add(severity, message = nil, progname = nil, &block)
    @loggers.each { |logger| logger.add(severity, message, progname, &block) }
  end

  def <<(message)
    @loggers.each { |logger| logger << message }
  end

  def close
    @loggers.each(&:close)
  end

  def respond_to_missing?(method_name, include_private = false)
    @loggers.all? { |logger| logger.respond_to?(method_name, include_private) }
  end

  def method_missing(method, *args, &block)
    if respond_to_missing?(method)
      @loggers.each { |logger| logger.send(method, *args, &block) }
    else
      super
    end
  end
end
