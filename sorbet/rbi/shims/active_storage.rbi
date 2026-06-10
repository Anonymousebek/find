# typed: true

module ActiveStorage
  class Attached::One
    sig { returns(T.untyped) }
    def content_type; end
  end
end
