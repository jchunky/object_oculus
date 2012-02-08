README for what\_methods
========================

This is from Dr. Nic.  See http://drnicwilliams.com/2006/10/12/my-irbrc-for-consoleirb/

Ever asked: “if I have an object, what method can I call on it to get that result?”

See if this suits your console cravings:

    > 3.45.what? 3
    3.45.to_i()     == 3
    3.45.to_int()   == 3
    3.45.floor()    == 3
    3.45.round()    == 3
    3.45.truncate() == 3
    => {:to_i=>3, :to_int=>3, :floor=>3, :round=>3, :truncate=>3}

    > 3.45.what? 4
    3.45.ceil() == 4
    => {:ceil=>4}

    > 3.55.what? 4
    3.55.ceil()  == 4
    3.55.round() == 4
    => {:ceil=>4, :round=>4}

    > 3.45.what? /\n/
    3.45.psych_to_yaml()  == "--- 3.45\n...\n"
    3.45.to_yaml()        == "--- 3.45\n...\n"
    3.45.pretty_inspect() == "3.45\n"
    => {:psych_to_yaml=>"--- 3.45\n...\n", :to_yaml=>"--- 3.45\n...\n", :pretty_inspect=>"3.45\n"}
    
    > 3.what?(4,1)
    3 + 1  == 4
    => {:+=>4}

Just what you need in the console.

Notice the last example: you can pass parameters after the desired result.  What? will tell
you what method will return the desired result if you pass those parameters to it.

Note also the addition of helpers like `exactly?`, which will make only find exactly matches,
and `matches?`, which will match a regular expression:

    > 5.exactly? 5.0
    5.to_f() == 5.0
    => {:to_f=>5.0}

    > "hello".matches? /^\d$/
    "hello".length()   == 5
    "hello".size()     == 5
    "hello".bytesize() == 5
    "hello".to_i()     == 0
    "hello".hex()      == 0
    "hello".oct()      == 0
    => {:length=>5, :size=>5, :bytesize=>5, :to_i=>0, :hex=>0, :oct=>0}
