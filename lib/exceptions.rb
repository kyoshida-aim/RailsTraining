module Exceptions
  class NonAdminUserAccess < StandardError
    def initialize(message = nil)
      message ||= "Access attempt from non-admin user detected"
      super(message)
    end
  end

  class UnableToDestroyLastAdmin < StandardError
    def initialize(message = nil)
      message ||= "Unable to destroy admin user because no other admin user exists"
      super(message)
    end
  end
end
