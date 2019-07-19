module Exceptions
  class NonAdminUserAccess < StandardError
    def initialize(message = nil)
      message ||= "Access attempt from non-admin user detected"
      super(message)
    end

    def logger_message
      "<<#{self.class}: #{self.message}>>"
    end
  end
end
