require "whats_up"

module WhatsUp
  module Classic
    alias :what?      :what_equals
    alias :exactly?   :whats_exactly
    alias :matches?   :what_matches
    alias :works?     :what_works_with
    alias :not_blank? :whats_not_blank_with
  end

  class MethodFinder
    @@blacklist += %w(what? exactly? matches? works? not_blank?)
  end
end

class Object
  include WhatsUp::Classic
end
