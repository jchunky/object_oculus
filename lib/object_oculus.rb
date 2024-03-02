# object_oculus enables you to determine what methods can be called on an object that return a given
# value
#
# === Some credits from Dr. Nic
#
# Code this version is based on: {Andrew
# Birkett's}[http://www.nobugs.org/developer/ruby/method_finder.html]
#
# Improvements from Why's blog entry:
# * +what?+ - Why
# * <tt>@@blacklist</tt> - llasram
# * +clone+ alias - Daniel Schierbeck
# * <tt>$stdout</tt> redirect - Why
#
# {Improvements from Nikolas Coukouma}[http://atrustheotaku.livejournal.com/339449.html]
# * Varargs and block support
# * Improved catching
# * Redirecting <tt>$stdout</tt> and <tt>$stderr</tt> (independently of Why)
#
# {A version posted in 2002 by Steven
# Grady}[http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-talk/32844]
#
# David Tran's versions:
# * Simple[http://www.doublegifts.com/pub/ruby/methodfinder.rb.html]
# * {Checks permutations of arguments}[http://www.doublegifts.com/pub/ruby/methodfinder2.rb.html]
module ObjectOculus
  autoload :Classic, "object_oculus/classic"
  autoload :DummyOut, "object_oculus/dummy_out"
  autoload :FrozenSection, "object_oculus/frozen_section"
  autoload :MethodFinder, "object_oculus/method_finder"
  autoload :Methods, "object_oculus/methods"
  autoload :VERSION, "object_oculus/version"
end

class Object # :nodoc:
  include ObjectOculus::Methods
end
