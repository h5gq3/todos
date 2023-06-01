::  random number agent ui

::TODO root component should be able to be a sail component

::  import agent state structure
/-  sur=todos
/+  ui2, ui3, ui4, default-agent

|%
+$  state
$:  todos=todos:sur
==
--

^-  web-component:ui4
=|  state
=*  state  -
::TODO need a custom bowl to include a map of agent names to paths to subscribe to
:: this map would be used at on-init to produce subscription cards
|_  [props=(unit vase) children=marl =bowl:ui4]
::
+*  this  .
    default  ~(. (default-agent this %|) bowl.bowl)
    pathmap  (~(put by *(map term (list path))) [%todosneli ~[/todos /add-todo /remove-todo /clear-todos /mark-done]])  :: this would come from the bowl map instead
    :: todos
    :: :~
    :: ['todo' %normal |]
    :: ==
::
++  on-init
  ^-  (quip card:agent:gall _this)
  :_  this
  %-  zing
  %+  turn  ~(tap by pathmap)
    |=  [=term paths=(list path)]
    %+  turn  paths
      |=  =path
      [%pass /component/[dit.bowl]/[-.path] %agent [our.bowl.bowl term] %watch path]
++  on-peek
  |=  =path
  ^-  (unit (unit cage))
  ~&  >  'todocontainer on-peek'
  ?+    path        (on-peek:default path)
      [%x %todos ~]
    ``[%noun !>(todos)]
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
  :: ~&  >  'todocontainer on-watch'
  ^-  (quip card:agent:gall _this)
  ?+    path  [~ this]
      [%event-listeners ~]
    `this
  ==
++  on-leave  on-leave:default
++  on-agent
  |=  [=wire =sign:agent:gall]
  :: ~&  >  'on-agent'
  :: ~&  wire
  :: ~&  sign
  ^-  (quip card:agent:gall _this)
  ?+    -.sign  (on-agent:default wire sign)
      %fact
    ?+    wire  `this
        [%todos ~]
        ~&  "initial todos"
        ~&  !<(todos:sur q.cage.sign)
      [~ this(todos !<(todos:sur q.cage.sign))]
        [%add-todo ~]
        ~&  "add todo"
      [~ this(todos (snoc todos !<([id:sur todo:sur] q.cage.sign)))]
        [%remove-todo ~]
        :: ~&  "removing todo"
        :: ~&  (skip todos |=(=todo:sur =(todo !<(todo:sur q.cage.sign))))
      [~ this(todos (skip todos |=([=id:sur =todo:sur] =(todo !<(todo:sur q.cage.sign)))))]
    ==
  ==
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
  `this
++  view
;div
  ;todoinput.sail-component;
 ;*  (turn todos |=([=id:sur =todo:sur] ;todo.sail-component(props (s:ui2 todo), key <`@`id>);))
::  ;*  (turn todos |=(=todo:sur ;todo(props (s:ui2 priority.todo)):"{(trip text.todo)}"))
==
--