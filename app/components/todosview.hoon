/-  sur=todos, ui
/+  ui4, agentio, default-agent

^-  web-component:ui4
|_  [props=(map mane vase) children=marl =bowl:ui4]
+*  this  .
    default  ~(. (default-agent this %|) bowl.bowl)
    io  ~(. agentio bowl.bowl)
::
++  on-init
  ^-  (quip card:agent:gall _this)
  `this
++  on-load  on-load:default
++  on-save  on-save:default
++  on-watch  on-watch:default
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
          ==
      ==
    ==
++  view
:: position the component in center of screen using tailwind classes
;div.absolute.inset-0.flex.flex-col.justify-center.items-center
  ;div.bg-white.rounded-lg.shadow-lg.max-w-lg
    ;div.p-4
      ;h2.text-2xl.font-bold.m-0
        ;span: todos
      ==
      ;Menu.sail-component
        ;Link.sail-component(to (s:ui4 /))
          ;span: all todos
        ==
        ;Link.sail-component(to (s:ui4 /active))
          ;span: active
        ==
        ;Link.sail-component(to (s:ui4 /completed))
          ;span: completed
        ==
      ==
      ;div.mt-4
        :: ;todoinput;
        ;div.flex.flex-row
          ;todocontainer.sail-component;
        ==
      ==
    ==
  ==
==
--