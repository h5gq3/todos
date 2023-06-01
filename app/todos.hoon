/-  *todos, ui
/+  default-agent, dbug, ui2, ui4
/=  todosview  /app/components/todosview
/=  todocontainer  /app/components/todocontainer
/=  todoinput  /app/components/todoinput
/=  todo-component  /app/components/todo
::/~  components  web-component:ui4  /components

=/  components=(map term web-component:ui4)
  (~(gas by *(map term web-component:ui4)) ~[todocontainer+todocontainer todo+todo-component todoinput+todoinput])

|%
+$  pokes
  $%  [%add =todo]
      [%remove =todo]
      [%clear ~]
      [%mark-done =todo]
  ==
+$  versioned-state
    $%  state-0
    ==
+$  state-0  [%0 =todos]
--
=|  state-0
=*  state  -
%+  agent:ui4  [todosview components]
^-  agent:gall
:: %+  agent:ui4  [todo *components:ui4]
|_  =bowl:gall
+*  this    .
    default  ~(. (default-agent this %|) bowl)
::
++  on-init
~&  >  'on-init'
    :_  this
  :~
  [%pass /eyre/connect %arvo %e %connect [~ /[dap.bowl]] dap.bowl]
  ==
++  on-save
  ^-  vase
  !>(state)
++  on-load
  |=  =old-state=vase
  =+  !<(old-state=state-0 old-state-vase)
  `this(state old-state)
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card:agent:gall _this)
  ~&  >  'on-poke'
  ?+    mark    (on-poke:default mark vase)
      %noun
    =/  pokes=pokes
      !<(pokes vase)
    ?-    -.pokes
        %add
      :_  this(todos (snoc todos [now.bowl todo.pokes]))
      :~
      [%give %fact ~[/add-todo] %add !>([now.bowl todo.pokes])]
      ==
        %remove
      =/  todos=^todos
        %+  skip  todos
        |=  [=id =todo]
        ^-  ?
        =(todo todo.pokes)
      :_  this(todos todos)
      :~
      [%give %fact ~[/remove-todo] %remove !>(todo.pokes)]
      ==
        %clear
      :_  this(todos ~)
      :~
      [%give %fact ~[/clear-todos] %clear !>(~)]
      ==
        %mark-done
      =/  todos=^todos
        %+  turn  todos
        |=  [=id =todo]
        ~&  "todo from poke"
        ~&  todo.pokes
        ?:  =(todo todo.pokes)
          [id todo(done !done.todo)]
        [id todo]
      :_  this(todos todos)
      :~
      [%give %fact ~[/mark-done] %mark-done !>(todo.pokes)]
      ==
    ==
  ==
++  on-watch
  |=  =path
  ^-  (quip card:agent:gall _this)
  ?+    path  [~ this]
      [%todos ~]
    :_  this
    :~
    [%give %fact ~ [%noun !>(todos)]]
    ==
      [%add-todo ~]
    :_  this
    ~
          [%remove-todo ~]
    :_  this
    ~
          [%clear-todos ~]
    :_  this
    ~
          [%mark-done ~]
    :_  this
    ~
  ==
++  on-leave
  |=  path
  `this
::
++  on-peek  on-peek:default
++  on-agent  on-agent:default
++  on-arvo
  |=  [=wire =sign-arvo]
  ^-  (quip card:agent:gall _this)
  ?+  sign-arvo  (on-arvo:default wire sign-arvo)
      [%eyre %bound *]
    ~?  !accepted.sign-arvo
      [dap.bowl 'eyre bind rejected!' binding.sign-arvo]
    [~ this]
  ==
++  on-fail  on-fail:default
--