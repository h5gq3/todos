:: todo input sail-component
/-  ui
/+  ui2, ui3, ui4, agentio, default-agent

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
|_  [props=(unit vase) children=marl =bowl:ui4]
::
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
      [%event-listeners ~]
    :_  this
    :~
    [%give %fact ~ [%json !>((all-domevents-json:ui3 ~[[dit.bowl ~[%keydown]]]))]]
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
    ~&  "component on-poke took"
    ~>  %bout
  |=  [=mark =vase]
  ^-  (quip card:agent:gall _this)
  ?+  mark  `this
    %ui
    =/  poke  !<(ui-poke:ui vase)
    :: ~&  poke
    ?+  -.poke  `this
      %domevent
        ?+  +<.poke  `this
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
                =/  todo
                  =/  text  (crip buffer)
                  =/  priority  %normal
                  =/  done  %.n
                  [text priority done]
                :_  this(buffer "")
                :: poke our agent to add a todo
                :~
                (~(poke-self pass:io /component-poke) %noun !>([%add todo]))
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
;input(ref <dit.bowl>, placeholder "add a todo, press enter", autofocus "true", value buffer);
--