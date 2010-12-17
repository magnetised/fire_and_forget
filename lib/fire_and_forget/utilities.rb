require "json"

module FireAndForget
  module Utilities
    def to_arguments(params={})
      params.keys.sort { |a, b| a.to_s <=> b.to_s }.map do |key|
        %(--#{key}=#{to_parameter(params[key])})
      end.join(" ")
    end

    def to_parameter(obj)
      if obj.is_a?(String)
        obj
      else
        JSON.generate(obj)
      end.inspect
    end
  end
end

