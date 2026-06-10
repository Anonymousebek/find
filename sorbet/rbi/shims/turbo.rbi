# typed: true

class ActiveRecord::Base
  extend Turbo::Broadcastable::ClassMethods
  extend Turbo::Broadcastable
end
