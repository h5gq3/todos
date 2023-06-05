::  menu component

/+  ui4, default-agent



^-  web-component:ui4
=/  state  1
=*  state  -
|_  [props=(map mane vase) children=marl =bowl:ui4]
::
+*  this  .
    default  ~(. (default-agent this %|) bowl.bowl)
::
++  on-init
  ^-  (quip card:agent:gall _this)
  `this
++  on-peek  on-peek:default
++  on-load
  |=  =old-state=vase
  =+  !<(old-state=@ old-state-vase)
  `this(state old-state)
++  on-save
  ^-  vase
  !>(state)
++  on-watch
  |=  =path
  ^-  (quip card:agent:gall _this)
  ?+    path  [~ this]
      [%event-listeners ~]
    `this
  ==
++  on-leave  on-leave:default
++  on-agent  on-agent:default
++  on-fail  on-fail:default
++  on-arvo  on-arvo:default
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card:agent:gall _this)
  `this
++  view
:: menu items next to each other
:: using tailwindcss
;div.flex.flex-row
  ;*  children
==
--