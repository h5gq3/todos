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
  (fact:io [%domevents !>([dit.bowl ~[%keydown]])] [/event-listeners]~)
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
    =/  poke  !<(ui-poke:ui vase)

    ?+  -.poke  `this
      %domevent
        ?+  +<.poke  `this
          %click
            ~&  "clicking at root"
            `this
          :: %submit
          ::   ~&  "submitting form"
          ::   `this
          %keydown
            :: ~&  +>.poke
            ~&  "pressed {<key:+>.poke>} key down"
            ~&  "buffer is {buffer}"
            =^  cards  this
            =/  handle-key
              ::  if key is a character, weld it to the buffer
              ?:  =(1 (lent (trip key:+>.poke)))  `this(buffer (weld buffer (trip key:+>.poke)))
              ::  if key is backspace, remove the last character from the buffer
              ?:  =("Backspace" (trip key:+>.poke))  `this(buffer (snip buffer))
              ::  if key is enter, set the seed to the buffer
              ?:  =("Enter" (trip key:+>.poke))
                ::  poke our agent with the seed
                :_  this(buffer "")
                :: poke our agent to add a todo
            ~&  "buffer is {buffer} when sending fact"
                :~
                [%give %fact ~[:(weld /component /[dit.bowl] /start-date)] %start-date !>(buffer)]
                ==
              ::  otherwise, do nothing
              `this
            handle-key
              ::
            [cards this]

          ==
      ==
    ==
++  view
;div.flex.flex-row
  ;p: select date
  ;form
    ;label(for "start-date"): start date
    ;input#start-date(type "date", name "start-date");
    ;label(for "end-date"): end date
    ;input#end-date(type "date", name "end-date");
    ;button#submit(type "submit", name "submit"): set
  ==
==
--