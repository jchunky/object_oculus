require "whats_up"

module WhatsUp
  # This module contains the original +what?+ method, as well as some aliases for newer methods. In
  # line with the current expectation that a Ruby method ending in +?+ returns a true or false value
  # (or at least something truthy or falsy), I've decided not to make +what?+ and it's brethren the
  # default. You can include them by:
  #
  #   require "whats_up/classic"
  #
  # or, if whats_up is already loaded:
  # 
  #   WhatsUp::Classic  # which triggers whats_up/classic to autoload
  module Classic
    alias :what?      :what_equals
    alias :exactly?   :whats_exactly
    alias :matches?   :what_matches
    alias :works?     :what_works_with
    alias :not_blank? :whats_not_blank_with
  end
end

class Object  # :nodoc:
  include WhatsUp::Classic
end
