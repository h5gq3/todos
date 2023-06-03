/-  sur=todos, ui
/+  ui4, agentio, default-agent, manx-tools
::
|%
+$  props
  $:  priority=?(%normal %high)
  ==
+$  state
  $:  todo=todo:sur
      checkbox-toggled=_|
      mouseover=_|
      mouseout=_|
  ==
--
::
^-  web-component:ui4
=|  state
=*  state  -
::TODO need a custom bowl to include a map of agent names to paths to subscribe to
:: this map would be used at on-init to produce subscription cards
|_  [props=(unit vase) children=marl =bowl:ui4]
+*  this  .
    default  ~(. (default-agent this %|) bowl.bowl)
    io  ~(. agentio bowl.bowl)
    pass  pass:io
++  on-init
  ^-  (quip card:agent:gall _this)
  =/  todo
  ?~  props  *todo:sur
    ;;(todo:sur !<(* u.props))
  :_  this(todo todo)
  :~
  (fact:io [%domevents !>([dap.bowl.bowl ~[%click %mouseenter %mouseleave]])] [/event-listeners]~)
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
    [%give %fact ~ [%json !>((all-domevents-json:ui4 ~[[dit.bowl ~[%click %mouseenter %mouseleave]]]))]]
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
    :: ~&  "component on-poke took"
    :: ~>  %bout
  |=  [=mark =vase]
  :: ~&  >  'todo on-poke'
  :: ~&  mark
  :: ~&  vase
  ^-  (quip card:agent:gall _this)
  :: `this
  ?+  mark  `this
    %ui
    =/  poke  !<(ui-poke:ui vase)
    ?+  -.poke  `this
      %domevent
        ?+  +<.poke  `this
          %click
  ::           :: reconstruct the todo from the props
  ::           =/  todo
  ::             =/  text  (crip (~(get-inner-text manx-tools *^manx) children))
  ::             =/  priority  priority.props
  ::             =/  done  checkbox-toggled
  ::             [text priority done]
  ::           ::  if click poke target-id is "close", send a %remove poke to the agent
  ::           ::
            ?:  =(+.target-id.+>.poke 'close')
            :: ~&  "close button clicked"
              =/  card
                ::TODO `%todos2` is hardcoded. need to handle this
                [%pass /component-poke %agent [our.bowl.bowl dap.bowl.bowl] %poke %noun !>([%remove todo])]
  ::               (~(poke-self pass:io /component-poke) [%noun !>([%remove todo])])
              [[card]~ this]
  ::           :: toggle the checkbox
  ::           :: ~&  "toggling checkbox"
  ::           ::
  ::           :: send a %mark-done poke to the agent to mark the todo as done
            =/  card
              [%pass /component-poke %agent [our.bowl.bowl dap.bowl.bowl] %poke %noun !>([%mark-done todo])]

              :: (~(poke-self pass:io /component-poke) [%noun !>([%mark-done todo])])
  ::           :: ~&  "children"
  ::           :: ~&  children
  ::           :: ~&  "reconstructed todo"
  ::           ~&  todo
            [[card]~ this(checkbox-toggled !checkbox-toggled)]
          %mouseenter
            :: ~&  "mouseover"
            `this(mouseover &, mouseout |)
          %mouseleave
            :: ~&  "mouseout"
            `this(mouseout &, mouseover |)
          ==
    ==
  ==
++  view
  :: ~&  children
  :: =/  props  ;;(^props !<(* vas))

  :: =/  no-of-zaps
  ::   ?~  children  0
  ::   %-  lent
  ::   (scan (~(get-inner-text manx-tools *^manx) children) ;~(pfix (star ;~(less zap prn)) (star zap)))
  :: =/  font-size
  ::   ?:  =(no-of-zaps 0)  "1em"
  ::   ?:  =(no-of-zaps 1)  "1.5em"
  ::   ?:  =(no-of-zaps 2)  "2em"
  ::   ?:  =(no-of-zaps 3)  "2.5em"
  ::   ?:  =(no-of-zaps 4)  "3em"
  ::   ?:  =(no-of-zaps 5)  "3.5em"
  ::   "1em"
  =/  input  ::TODO boolean attributes need to be handled differently since they don't have a value (e.g. checked="true")
    ?:  checkbox-toggled
      :: if checkbox is toggled, add the checked attribute
      :: add tailwind classes to the input checkbox:
      :: if checkbox-toggled, add green bg
      :: add other tailwind classes: "rounded-sm"
      ;input#cbox.bg-green-500.rounded-sm.mr-1(ref <dit.bowl>, type "checkbox", checked "true");
      :: ;input.bg-green-500(ref this.bowl, type "checkbox", checked "true");
    :: if checkbox is not toggled, don't add the checked attribute
    :: add tailwind classes to the input checkbox:
    :: if checkbox-toggled is false, add white bg
    :: add other tailwind classes: margin-right: 0.25rem
    ;input.bg-white.mr-1(ref <dit.bowl>, type "checkbox");
    :: ;input(ref this.bowl, type "checkbox");
  =/  close-button
    ?:  mouseover
      ;span#close(ref <dit.bowl>):"x"
    ;/  ~
  ::   :: add tailwind classes to the close button:
  ::   :: if mouseover, add red bg
  ::   :: if mouseout, add white bg
  ::   :: add other tailwind classes: "rounded-sm"
  ::   ;button.bg-white.rounded-sm(ref this.bowl)
  ::     :: add tailwind classes to the close button:
  ::     :: if mouseover, add red bg
  ::     :: if mouseout, add white bg
  ::     :: add other tailwind classes: "rounded-sm"
  ::     ;svg(ref this.bowl, xmlns "http://www.w3.org/2000/svg", viewBox "0 0 20 20", fill "currentColor")
  ::       :: add tailwind classes to the close button:
  ::       :: if mouseover, add red bg
  ::       :: if mouseout, add white bg
  ::       :: add other tailwind classes: "rounded-sm"
  ::       ;path(ref this.bowl, stroke-linecap "round", stroke-linejoin "round", stroke-width "2", d "M6 18L18 6M6 6l12 12");
  ::     ==
  ::   ==
  ::
  ::
    ;div(ref <dit.bowl>, style "display: flex; flex-direction: row; flex: 1 1 auto; min-height: 0; overflow: auto;")
      ;+  input
        :: add tailwind classes:
        :: if checkbox-toggled, add "line-through"
        :: if priority is high, add "font-bold"
        :: if no-of-zaps is 0, add "text-sm"
        :: if no-of-zaps is 1, add "text-base"
        :: if no-of-zaps is 2, add "text-lg"
        :: if no-of-zaps is 3, add "text-xl"
        :: if no-of-zaps is 4, add "text-2xl"
        :: if no-of-zaps is 5, add "text-3xl"
      ;p
        =class  "{?:(checkbox-toggled "line-through" "")}"
        ;  {(trip text.todo)}
      ==
    ;+  close-button
  ==
--