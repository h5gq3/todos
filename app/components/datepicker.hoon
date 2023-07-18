/-  sur=todos, ui
/+  ui4, agentio, default-agent

|%
+$  state
  $:  buffer=tape
  ==
--
::
=|  state
=*  state  -
::
^-  web-component:ui4
|_  [props=(map mane vase) children=marl =bowl:ui4]
+*  this  .
    default  ~(. (default-agent this %|) bowl.bowl)
    io  ~(. agentio bowl.bowl)
::
++  on-init
  ^-  (quip card:agent:gall _this)
  :_  this
  :~
  (fact:io [%domevents !>([dit.bowl ~[%submit]])] [/event-listeners]~)
  ==
++  on-load
  |=  =old-state=vase
  =+  !<(old-state=^state old-state-vase)
  `this(state old-state)
++  on-save
  ^-  vase
  !>(state)
++  on-watch
  |=  =path
  :: ~&  >  'todo on-watch'
  ^-  (quip card:agent:gall _this)
  ?+    path  [~ this]
      [%start-date ~]  `this
      [%end-date ~]  `this
      [%event-listeners ~]
    :_  this
    :~
    [%give %fact ~ [%json !>((all-domevents-json:ui4 ~[[dit.bowl ~[%keydown %submit]]]))]]
    ==
  ==
++  on-leave  on-leave:default
++  on-peek   on-peek:default
++  on-agent  on-agent:default
++  on-fail  on-fail:default
++  on-arvo
  |=  [=wire =sign-arvo]
  ^-  (quip card:agent:gall _this)
  ?+  sign-arvo  (on-arvo:default wire sign-arvo)
      [%eyre %bound *]
    ~?  !accepted.sign-arvo
      [dap.bowl.bowl 'eyre bind rejected!' binding.sign-arvo]
    [~ this]
  ==
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card:agent:gall _this)
  :: handle click
    ?+  mark  `this
    %ui
    =+  !<(poke=ui-poke:ui vase)
    ?+  -.poke  `this
      %domevent
        ?+  +<.poke  `this
          %submit
            ~&  "submitting form"
            =/  start-date  (~(got by entries.poke) 'start-date')
            =/  end-date  (~(got by entries.poke) 'end-date')
            :_  this
            :~
            [%give %fact ~[:(weld /component /[dit.bowl] /start-date)] %start-date !>(start-date)]
            [%give %fact ~[:(weld /component /[dit.bowl] /end-date)] %end-date !>(end-date)]
            ==
          ==
      ==
    ==
++  view
;div.flex.flex-row
  ;p: select date
  :: we add ref of this component to form so we can handle submit event in on-poke
  ;form(ref <dit.bowl>)
    ;label(for "start-date"): start date
    ;input#start-date(type "date", name "start-date");
    ;label(for "end-date"): end date
    ;input#end-date(type "date", name "end-date");
    ;button#submit(type "submit", name "submit"): set
  ==
==
--