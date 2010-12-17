

module FireAndForget
  class Error < ::StandardError; end
  class PermissionsError < Error; end
  class FileNotFoundError < Error; end
end

