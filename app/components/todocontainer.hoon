/-  sur=todos
/+  ui4, default-agent

|%
+$  state
$:  todos=todos:sur
    start-date=tape
    end-date=tape
==
--

^-  web-component:ui4
=|  state
=*  state  -
|_  [props=(map mane vase) children=marl =bowl:ui4]
::
+*  this  .
    default  ~(. (default-agent this %|) bowl.bowl)
::
++  on-init
  ^-  (quip card:agent:gall _this)
  :_  this
  =/  paths
    %-  ~(put by *(map term (list path)))
    :-  dap.bowl.bowl
        :~  /todos
            /add-todo
            /remove-todo
            /clear-todos
            /mark-done
        ==
  %-  zing
  %+  turn  ~(tap by paths)
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
  ~&  >  'todocontainer on-agent'
  ~&  wire
  ~&  sign
  ^-  (quip card:agent:gall _this)
  ?+    -.sign  (on-agent:default wire sign)
      %fact
    ?+    wire  `this
        [%start-date ~]
      [~ this(start-date (trip !<(cord q.cage.sign)))]
        [%end-date ~]
      [~ this(end-date (trip !<(cord q.cage.sign)))]
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
        [%clear-todos ~]
      [~ this(todos ~)]
        [%mark-done ~]
      =/  todo  !<(todo:sur q.cage.sign)
      =.  todos
        %+  turn  todos
        |=  [=id:sur =todo:sur]
        ?:  =(todo ^todo)
          [id todo(done !done.todo)]
        [id todo]
      [~ this]
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
  ~&  >  'todocontainer view'
  ~&  site.url-path.bowl
  =/  default
    ;div
      ;todoinput.sail-component;
    ;*  (turn todos |=([=id:sur =todo:sur] ;todo.sail-component(todo (s:ui4 todo), key <`@`id>);))
    ==
  =/  completed
    =.  todos
      %+  skim  todos
      |=  [=id:sur =todo:sur]
      done.todo
  ::  we can either parse form data from the url or get it from the subscription to the datepicker
  :: =/  start-date
  ::   =/  url-args  (malt args.url-path.bowl)
  ::   =+  (~(get by url-args) 'start-date')
  ::   ?~  -  ""  (trip u.-)
  :: =/  end-date
  ::   =/  url-args  (malt args.url-path.bowl)
  ::   =+  (~(get by url-args) 'end-date')
  ::   ?~  -  ""  (trip u.-)
    ;div
      ;datepicker#datepicker.sail-component(subscribe (s:ui4 [dit.bowl ~[/start-date /end-date]]));
      ;p:"selected start date:{start-date}"
      ;p:"selected end date:{end-date}"
      ;todoinput.sail-component;
    ;*  (turn todos |=([=id:sur =todo:sur] ;todo.sail-component(todo (s:ui4 todo), key <`@`id>);))
    ==
  =/  active
    =.  todos
      %+  skip  todos
      |=  [=id:sur =todo:sur]
      done.todo
    ;div
      ;todoinput.sail-component;
    ;*  (turn todos |=([=id:sur =todo:sur] ;todo.sail-component(todo (s:ui4 todo), key <`@`id>);))
    ==
  ::
  :: =/  url-path  (parse-request-line:ui4 url-path.bowl)
  ?+  site.url-path.bowl  default
      ~
    default
      [%completed ~]
    completed
      [%active ~]
    active
  ==
--