require "json"

module FireAndForget
  module Utilities
    def to_arguments(params={})
      params.keys.sort { |a, b| a.to_s <=> b.to_s }.map do |key|
        %(--#{key}=#{to_json(params[key])})
      end.join(" ")
    end

    def to_json(obj)
      if obj.is_a?(String)
        obj.inspect
      else
        JSON.generate(obj)
      end
    end
  end
end

