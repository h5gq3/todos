|%
+$  wrapper-state
  $:  components-state=(map dit=term component-state)
      subscriptions=(map path (list term))
      url-path=path
  ==
+$  component-state
  $:  cab=term
      sta=vase
      viw=manx
      pop=(map mane vase)
      sot=marl
  ==
+$  ui-poke
  $%  [%domevent dom-event]
      [%new-component [dit=term cab=term pop=(map mane vase) sot=marl]]
      [%remove-component dit=term]
      [%forward-subscription [dit=term [=wire =sign:agent:gall]]]
      [%new-path =path]
  ==
+$  dom-event
  $%  [%click click-event]
      [%keydown key-down-event]
      [%mouseenter mouse-enter-event]
      [%mouseleave mouse-leave-event]
  ==
+$  click-event
  $:  target=cord
      target-id=(unit cord)
  ==
+$  key-down-event
  $:  target=cord
      key=cord
      target-id=(unit cord)
  ==
+$  mouse-enter-event
  $:  target=cord
      target-id=(unit cord)
  ==
+$  mouse-leave-event
  $:  target=cord
      target-id=(unit cord)
  ==

::
++  json-to-poke
  =,  dejs:format
  |^
  %-  of
  :~  domevent+dom-event
      new-path+pa
  ==
  ++  dom-event
  %-  of
  :~  click+click-event
      keydown+key-down-event
      mouseenter+mouse-enter-event
      mouseleave+mouse-leave-event
  ==
  ++  click-event
    %-  ot
  :~
    [%target so]
    [%target-id so:dejs-soft]
  ==
  ++  key-down-event
    %-  ot
  :~
    [%target so]
    [%key so]
    [%target-id so:dejs-soft]
  ==
  ++  mouse-enter-event
    %-  ot
  :~
    [%target so]
    [%target-id so:dejs-soft]
  ==
  ++  mouse-leave-event
    %-  ot
  :~
    [%target so]
    [%target-id so:dejs-soft]
  ==
  --
::
++  all-domevents-json
  |=  events=(list [@t (list term)])
  ^-  json
  :-  %a
  %+  turn  events
  |=  [e=[@t (list term)]]
  %+  frond:enjs:format
  -.e
  :-  %a
  %+  turn  +.e
  |=  [t=term]
  ^-  json
  s+t
::
--