
module FireAndForget
  module Utilities
    def to_arguments(params={})
      params.keys.sort { |a, b| a.to_s <=> b.to_s }.map do |key|
        %(--#{key}=#{to_parameter(params[key])})
      end.join(" ")
    end

    # Maps objects to command line parameters suitable for parsing by Thor
    # @see https://github.com/wycats/thor
    def to_parameter(obj)
      case obj
      when String
        obj.inspect
      when Array
        obj.map { |o| to_parameter(o.to_s) }.join(' ')
      when Hash
        obj.map do |k, v|
          "#{k}:#{to_parameter(obj[k])}"
        end.join(' ')
      when Numeric
        obj
      else
        to_parameter(obj.to_s)
      end
    end
  end
end

