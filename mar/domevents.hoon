/+  ui2
|_  events=[@t (list term)]
++  grow
  |%
  ++  noun  events
  ++  json
    ^-  ^json
    :-  %a
    ^-  (list ^json)
    :~
    %+  frond:enjs:format
    -.events
    :-  %a
    %+  turn  +.events
    |=  [t=term]
    ^-  ^json
    s+t
    ==
  --
++  grab
  |%
  ++  noun  [@t (list term)]
  :: ++  json  json-to-poke:ui2
  --
++  grad  %noun
--
