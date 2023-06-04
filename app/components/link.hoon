::  link component
/-  ui
/+  ui4, default-agent

^-  web-component:ui4
:: =|  state
:: =*  state  -
|_  [props=(unit vase) children=marl =bowl:ui4]
::
+*  this  .
    default  ~(. (default-agent this %|) bowl.bowl)
    :: props  ;;  (map term vase)  ::TODO
::
++  on-init
  ^-  (quip card:agent:gall _this)
  `this
++  on-peek  on-peek:default
++  on-load  on-load:default
++  on-save  on-save:default
++  on-watch
  |=  =path
  :: ~&  >  'todocontainer on-watch'
  ^-  (quip card:agent:gall _this)
  ?+    path  [~ this]
      [%event-listeners ~]
    :_  this
    :~
    [%give %fact ~ [%json !>((all-domevents-json:ui4 ~[[dit.bowl ~[%click]]]))]]
    ==
  ==
++  on-leave  on-leave:default
++  on-agent  on-agent:default
++  on-fail  on-fail:default
++  on-arvo  on-arvo:default
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card:agent:gall _this)
    ?+  mark  `this
    %ui
    =/  poke  !<(ui-poke:ui vase)
    ?+  -.poke  `this
      %domevent
        ?+  +<.poke  `this
          %click  `this  ::TODO


++  view
;div
  ;*  children
==
--