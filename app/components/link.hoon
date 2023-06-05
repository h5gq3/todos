::  link component
/-  ui
/+  ui4, default-agent

|%
+$  state
$:  clicked=_|
    current-url-path=path
==
--

^-  web-component:ui4
=|  state
=*  state  -
|_  [props=(map mane vase) children=marl =bowl:ui4]
::
+*  this  .
    default  ~(. (default-agent this %|) bowl.bowl)
    :: to      (~(get by props) %to)
::
++  on-init
  ^-  (quip card:agent:gall _this)
  `this
++  on-peek  on-peek:default
++  on-load
  |=  =old-state=vase
  =+  !<(old-state=^state old-state-vase)
  :: we check if url-path has changed after we recorded the url-path at link click
  =?  clicked.old-state  !=(current-url-path.old-state url-path.bowl)
    |
  =?  current-url-path.old-state  !=(current-url-path.old-state url-path.bowl)
    url-path.bowl
  `this(state old-state)
++  on-save
  ^-  vase
  !>(state)
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
  :: ~&  >  'link on-poke'
  :: ~&  props
  :: ~&  children
  ^-  (quip card:agent:gall _this)
    ?+  mark  `this
        %ui
      =/  poke  !<(ui-poke:ui vase)
        ?+  -.poke  `this
            %domevent
          ?+  +<.poke  `this
              %click
            :: ~&  >  'link click on-poke'
            =/  to  (~(get by props) %to)
            ?~  to
            :: ~&  "link to null"
            `this  ::TODO handle null props
            =/  go-to
              ;;(path !<(* u.to))
            =/  card
              [%pass /navigation-poke %agent [our.bowl.bowl dap.bowl.bowl] %poke [%ui !>([%new-path go-to])]]
            :: ~&  >  'go to path'
            :: ~&  go-to
            =.  clicked  &
            =.  current-url-path  url-path.bowl
            [[card]~ this]
          ==
        ==
    ==
++  view
=/  clicked-style=tape
=+  (~(get by props) %clicked-style)
?~  -  ""
?.  clicked  ""
;;(tape !<(* u.-))
;div.m-1
  ;*  (turn children |=(c=manx =.(a.g.c (weld a.g.c `mart`~[[%ref <dit.bowl>] [%class clicked-style]]) c)))  ::TODO test deeper children
==
--