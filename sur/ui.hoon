|%
+$  wrapper-state
  $:  components-state=(map dit=term component-state)
      subscriptions=(map path (list term))
      url-path=request-line
      eyre-binding=binding:eyre
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
      :: [%forward-subscription [dit=term [=wire =sign:agent:gall]]]
      [%new-path path=cord]
  ==
+$  request-line
  $:  [ext=(unit @ta) site=(list @t)]
      args=(list [key=@t value=@t])
  ==
+$  dom-event
  $%  [%click click-event]
      [%keydown key-down-event]
      [%mouseenter mouse-enter-event]
      [%mouseleave mouse-leave-event]
      [%submit form-submit-event]
  ==
+$  click-event
  $:  target=cord
      target-id=(unit cord)
  ==
+$  key-down-event
  $:  target=cord
      target-id=(unit cord)
      key=cord
  ==
+$  mouse-enter-event
  $:  target=cord
      target-id=(unit cord)
  ==
+$  mouse-leave-event
  $:  target=cord
      target-id=(unit cord)
  ==
+$  form-submit-event
  $:  target=cord
      target-id=(unit cord)
      entries=(map cord cord)
  ==

::
++  json-to-poke
  =,  dejs:format
  :: ^-  $-(json ui-poke)
  :: ;;  $-(json ui-poke)
  |^
  %-  of
  :~  domevent+dom-event
      new-component+new-component
      remove-component+remove-component
      new-path+so
      :: :-  %new-path
      :: |=  jon=json
      :: ^-  request-line
      :: ?>  ?=([%s *] jon)
      :: (fall (rush p.jon ;~(plug apat:de-purl:html yque:de-purl:html)) [[~ ~] ~])
  ==
  ++  new-component
    |=(json *[dit=term cab=term pop=(map mane vase) sot=marl])
  ++  remove-component
    |=(json *[dit=term])
  ++  dom-event
  %-  of
  :~  click+click-event
      keydown+key-down-event
      mouseenter+mouse-enter-event
      mouseleave+mouse-leave-event
      submit+form-submit-event
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
    [%target-id so:dejs-soft]
    [%key so]
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
  ++  form-submit-event
    %-  ot
    :~
      [%target so]
      [%target-id so:dejs-soft]
      [%entries (cork (ar (at ~[so so])) malt)]
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