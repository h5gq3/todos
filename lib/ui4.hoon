/-  html-tag, html-attr, *ui
/+  default-agent, server, agentio, manx-tools, ui2

=|  wrapper-state
=*  wrapper-state  -

|%
++  card  card:agent:gall
::
+$  eyre-id  @ta
::
+$  bowl
  $:  dit=term
      cab=term
      =bowl:gall
  ==
::
+$  component-sample
  $:  props=(map mane vase)
      children=marl
      =bowl
  ==
::
++  make-bowl
  |=  [=bowl:gall [dit=term cab=term]]
  ^-  ^bowl
  [dit cab bowl]
::
++  all-domevents-json
  |=  events=(list [@t (list term)])
  ^-  json
  :-  %a
  %+  turn  events
  |=  [e=[@t (list term)]]
  %+  frond:enjs:format
  -.e
  :-  %a
  %+  turn  +.e
  |=  [t=term]
  ^-  json
  s+t
::
++  s
  |=  a=*
  ^-  tape
  <(jam a)>
::
++  apply-elem
  |=  [a=manx parent=@ self=@ b=$-([marx [@ @]] marx)]
  |^  ^-  manx
  =/  new-marx  (b g.a [parent self])
  :: ?.  ?|  |(?=(html-tag:html-tag n.g.a) ?=(%$ n.g.a))
  ::         !=(~ (~(get-attr manx-tools *manx) g.a %sail-id))
  ::         :: ==
  ::     ==
  ::   $(a (~(append-child manx-tools ;div.sail-component(sail-id (need (~(get-attr manx-tools *manx) new-marx %sail-id)));) `manx`[new-marx c.a]))
  :: ~&  "{<;;(@tas n.g.a)>} parent is {<parent>} and self is {<self>}"
  [new-marx (cloop(parent :(add (mug n.g.a) (mug parent) (mug self)), self 0) c.a)]
  ++  cloop
    |=  c=marl
    ?~  c  ~
    [^$(a i.c, self +(self)) (cloop(self +(self)) t.c)]
  --
++  generate-id
  |=  [=marx p=@ s=@]  ^-  ^marx
  ?:  ?=(%$ n.marx)  marx
  ?:  ?=(html-tag:html-tag n.marx)  marx
  :: ::~&  "marx"
  :: ::~&  marx
  ?:  (~(has by (malt a.marx)) %sail-id)
  :: ::~&  "has sail-id, skipping"
  marx
  =/  key  (~(get by (malt a.marx)) %key)
  =/  id=@
    ?~  key
      :(add (mug n.marx) (mug p) (mug s))
      :(add (mug n.marx) (mug p) (slav %ud (crip u.key)))
    :: :(mul (mug n.marx) p s)
  =.  a.marx
  (snoc a.marx [%sail-id (weld "c" (a-co:co id))])
  marx
::
++  with-id
  |=  [=manx dit=term]
  ^-  ^manx
  (apply-elem manx (mug dit) 0 generate-id)
::
++  web-component
  $_  ^|
  |_  [props=(map mane vase) children=marl =bowl]
  ++  view  *manx
  ::
  ++  on-init
    *(quip card _^|(..on-init))
  ::
  ++  on-save
    *vase
  ::
  ++  on-load
    |~  vase
    *(quip card _^|(..on-init))
  ::
  ++  on-poke
    |~  [mark vase]
    *(quip card _^|(..on-init))
  ::
  ++  on-watch
    |~  path
    *(quip card _^|(..on-init))
  ::
  ++  on-leave
    |~  path
    *(quip card _^|(..on-init))
  ::
  ++  on-peek
    |~  path
    *(unit (unit cage))
  ::
  ++  on-agent
    |~  [wire sign:agent:gall]
    *(quip card _^|(..on-init))
  ::
  ++  on-arvo
    |~  [wire sign-arvo]
    *(quip card _^|(..on-init))
  ::
  ++  on-fail
    |~  [term tang]
    *(quip card _^|(..on-init))
  --
::
+$  components
  (map term web-component)
::
++  full-document
  |=  [view=manx =bowl:gall]
  ^-  manx
  |^
  ;html(hidden "true")
    ;+  head
    ;+  body
  ==
  ++  head
    ;head
    ;script(type "module"):"{script}"
    ==
  ++  body
    ;body
    ;+  view
    ==
  ++  script
  """
  import Urbit from 'https://cdn.skypack.dev/@urbit/http-api';

  import \{ innerHTML, outerHTML, use, release, html } from 'https://cdn.skypack.dev/diffhtml';

  import \{ setup, disconnect } from 'https://cdn.skypack.dev/twind/shim'

  // create a queue to store tasks that need to be run after the render transaction
  var queue = [];

  // create a map `listener -> [sail-id]` to store sail-ids that need to be poked
  var eventListeners = new Map();

  // create a map `sail-id -> event` to toggle events that fire for a sail-id
  // this is used to prevent events from firing multiple times for the same sail-id
  var eventToggles = new Map();

  // for debugging
  window.innerHTML = innerHTML;
  window.outerHTML = outerHTML;
  //window.use = use;
  window.release = release;
  window.html = html;

  window.ship = "{(oust [0 1] "{<our.bowl>}")}";
  const api = new Urbit("");
  window.api = api
  api.ship = window.ship;


  var components = Array.from(document.querySelectorAll('.sail-component')).map((e) => e.getAttribute('sail-id'));

  // populate eventToggles with sail-ids
  components.forEach((id) => \{
    eventToggles.set(id, \{});
  });

  // validate ref attribute
  // ref attribute starts with `%`, we need to remove it
  function validateRef(str) \{
    if (str) \{
  if (str.startsWith('%')) \{
    return str.slice(1);
  }
  return str;
  }
  }

  const doMorph = (e, id) => \{
      console.log('doMorph', e, id)
      console.log('components at morph', components) 
      var element = document.querySelector(`[sail-id='$\{id}']`);
      if (!element) \{
          console.log('element not found')
          return
      } else \{
        //element.innerHTML = ''
      innerHTML(element, e)
      }
  }

  const target = (event) => \{
      if (event.target.getAttribute('ref')) \{
          return validateRef(event.target.getAttribute('ref'))
      } else \{
          return event.target.getAttribute('sail-id')
      }
  }

  const createListenerObject = (listener, event) => \{
      return \{
          target: target(event),
          'target-id': event.target.id,
          ...(listener === 'keydown' && \{key: event.key})

      }
  }

  function handlePokeAck(listener, event) \{
      console.log('handlePokeAck', listener, event)
      var id = target(event);
      eventToggles.get(id)[listener] = false;
  }

  function eventPoke(listener, event) \{
          //console.log('event-poke', listener, event.target, event.currentTarget)
          api.poke(\{
              app: "{(trip dap.bowl)}",
              mark: "ui",
              json: \{domevent:\{[listener]:createListenerObject(listener, event)}},
              onSuccess: () => handlePokeAck(listener, event),
              onError: () => console.log('Error poke')
          })
  }

  function kick(component) \{
      console.log('kick', component)
      var el = document.querySelector(`[sail-id='$\{component}']`);
      if (el) \{
          console.log('kick', el)
          //el.remove();
          //release(el);
      }

  }



  // add listeners to document

  ['click', 'keydown', 'mouseenter', 'mouseleave'].forEach((event) => \{
      document.addEventListener(event, (e) => \{
          //console.log(e.target.getAttribute('ref'), e.target.getAttribute('sail-id'))
          //console.log('event', event, e.target, eventListeners)
          if (e.target.getAttribute) \{
          if (e.target.getAttribute('ref') || e.target.getAttribute('sail-id')) \{
              if (eventListeners.has(event)) \{
                  if (eventListeners.get(event).includes(validateRef(e.target.getAttribute('ref'))) || eventListeners.get(event).includes(e.target.getAttribute('sail-id'))) \{
                    if (!eventToggles.get(target(e))[event]) \{
                      eventPoke(event, e)
                      console.log('event-poke', event, e.target, e.currentTarget)
                      eventToggles.get(target(e))[event] = true;
                    }
                  }
              }
          }
          }
      }, true)
  })

  const addEventListeners = (e) => \{
      console.log('addEventListeners', e)
      e.forEach((el) => \{
          var domEl = document.querySelector(`[sail-id='$\{Object.keys(el)[0]}']`)
          var listeners = Object.values(el)[0]
          if (domEl) \{
              //console.log('adding event listener to domEl', domEl)
              // populate eventToggles with listeners for this sail-id
              // sail-id -> \{listener: false}
              eventToggles.set(domEl.getAttribute('sail-id'), listeners.reduce((acc, listener) => \{
                  acc[listener] = false;
                  return acc;
              }, \{}))
              listeners.forEach((listener) => \{
                  //console.log('adding event listener to eventListeners map', listener)
                  if (eventListeners.has(listener)) \{
                    // push the domEl sail-id to the array of sail-ids for this listener
                      eventListeners.get(listener).push(domEl.getAttribute('sail-id'))
                  } else \{
                      eventListeners.set(listener, [domEl.getAttribute('sail-id')])
                  }
              })
          }
          else \{
              console.log('domEl not found', `[sail-id='$\{Object.keys(el)[0]}']`)
              queue.push(el)
          }
      })
  }

  function getUniqueElements(array1, array2) \{
  const union = [...new Set([...array1, ...array2])];
  const uniqueElements = union.filter(element => !array1.includes(element));
  return uniqueElements;
  }

  function someTask(transaction) \{
    //console.log('Start of render transaction:', transaction);

    return () => \{
      console.log('End of render transaction scheduled');

      transaction.onceEnded(() => \{
        console.log('state', transaction.state);
        //console.log('End of render transaction completed');
        // run queued addEventListener tasks
        addEventListeners(queue);
        queue = [];
        let newComponents = Array.from(document.querySelectorAll('.sail-component')).map((e) => e.getAttribute('sail-id'));
        // get new components
        let diff = getUniqueElements(components, newComponents);
        let old = getUniqueElements(newComponents, components);
        // unsubscribe from old components
        old.forEach((component) => \{
            console.log('unsubscribing from', component)
            release(document.querySelector(`[sail-id='$\{component}']`));
            // remove from eventListeners map
            eventListeners.forEach((value, key) => \{
                if (value.includes(component)) \{
                    eventListeners.set(key, value.filter((el) => el !== component))
                }
            eventToggles.delete(component)
            })
        
        });
        // update components
        components = newComponents;
        // subscribe to new components
        diff.forEach((component) => \{
            console.log('subscribing to', component)
            api.subscribe(\{
                  app: "{(trip dap.bowl)}",
                  path: `/component/$\{validateRef(component)}/event-listeners`,
                  event: addEventListeners,
                  quit: () => kick(component),
                  err: () => console.log('Error')
                });
        });

        diff.forEach((component) => \{
            api.subscribe(\{
                  app: "{(trip dap.bowl)}",
                  path: `/$\{validateRef(component)}/view`,
                  event: (e) => doMorph(e, component),
                  quit: () => kick(component),
                  err: () => console.log('Error')
                });
        });

      });
    };
  }

  use(someTask);

  components.forEach((component) => \{
    console.log('subscribing to', component)
    api.subscribe(\{
          app: "{(trip dap.bowl)}",
          path: `/component/$\{validateRef(component)}/event-listeners`,
          event: addEventListeners,
          quit: () => kick(component),
          err: () => console.log('Error')
        });
  });   

  components.forEach((component) => \{
    api.subscribe(\{
          app: "{(trip dap.bowl)}",
          path: `/$\{validateRef(component)}/view`,
          event: (e) => doMorph(e, component),
          quit: () => kick(component),
          err: () => console.log('Error')
        });
  });
  """
--
::
++  agent
  |=  [[component=web-component =components] =agent:gall]
  ^-  agent:gall
  |_  =bowl:gall
  +*  this  .
      ag    ~(. agent bowl)
      cs  ;;(component-sample +<:component)
      :: og    ~(. component [*(unit vase) *marl *^bowl])
      og    ~(. component cs)
  ++  on-init
    ^-  (quip card:agent:gall agent:gall)
    ::  on initial agent creation, we loop through the root component's manx from view:og
    ::  we collect cards and put the produced manx and state to wrapper state map
    ::  all subsequent calls to this on-init will come from this on-poke
    ::  these calls initialize new components and put their produced manx and state to wrapper state map
    ::
    ::  check if root view is in state
    ::  if not, this means we're at initial agent on-init and need to put root view to state
    =^  cards  agent  on-init:ag
    =^  og-cards  component  on-init:og
    =/  state  on-save:og
    =/  view  (with-id view:og dit.bowl.cs)
    =.  components-state
      ?.  (~(has by components-state) %root)
        (~(put by components-state) %root [%root state view props.cs children.cs])
      (~(put by components-state) dit.bowl.cs [cab.bowl.cs state view props.cs children.cs])
    :: =.  components-state
    =/  flat-manx=(list manx)  ~(lvl-flatten-innertext manx-tools view)
    =.  flat-manx
      %+  skip  flat-manx
      |=  =manx
      |(?=(html-tag:html-tag n.g.manx) ?=(%$ n.g.manx))
    =/  components-list
      %+  turn  `(list manx)`flat-manx
      |=  =manx
      :: ~&  manx
      ^-  [term term (map mane vase) marl]
      :^  ^-  term
          %-  crip
          (need (~(get-attr manx-tools *^manx) g.manx %sail-id))
          ::
          ;;(term n.g.manx)
          ::
          ^-  (map mane vase)
          =.  a.g.manx
            :: (~(del-attrs manx-tools manx) (silt ~[%sail-id %key]))
            %+  skip  a.g.manx
            |=  [attr=mane val=tape]
            :: ?=(html-attr:html-attr attr)
            |(?=(%sail-id attr) ?=(%key attr) ?=(html-attr:html-attr attr))
          %-  ~(run by (malt a.g.manx))
          |=  val=tape
          =+  (slaw %ud (crip val))
          ?~  -  !>(~)
          !>((cue u.-))
          ::
          c.manx
    =/  new-component-cards
      %+  turn  components-list
        |=  [dit=term cab=term pop=(map mane vase) sot=marl]
        ^-  card:agent:gall
        :: [%pass /start-agent %arvo %g [%jole q.byk.bowl dap !>(agent)]]
        [%pass /new-component %agent [our.bowl dap.bowl] %poke [%ui !>([%new-component [dit cab pop sot]])]]
    =.  cards  :(weld new-component-cards og-cards cards)
    :: [cards this(current-manx (component-div-tag (with-id view:og)))]
    [cards this]
    :: [~ this]
  ::
  ++  on-save  !>([[%ui-wrapper wrapper-state] on-save:ag])
  ::
    ++  on-load
    |=  ole=vase
    :: ::::~&  sail
    ^-  (quip card:agent:gall agent:gall)
    ?.  ?=([[%ui-wrapper *] *] q.ole)
    =^  cards  agent  (on-load:ag ole)
      [cards this]
    =+  !<([[%ui-wrapper old=^wrapper-state] ile=vase] ole)
    :: ::::~&  q.ile
    =^  cards  agent  (on-load:ag ile)
    [cards this(wrapper-state old)]
    :: [~ this]
  ::
  ++  on-poke
    |=  [=mark =vase]
    ^-  (quip card:agent:gall agent:gall)
    ?+  mark  =^  cards  agent  (on-poke:ag mark vase)
              [cards this]
      %handle-http-request
        :: =^  cards  agent  (on-poke:ag mark vase)  ::NOTE we can't do this when ag doesn't handle http request poke. maybe make a channge to default-agent lib?
        =^  cards  this
        =+  !<([=eyre-id =inbound-request:eyre] vase)
        =;  [=simple-payload:http =_this]
        :_  this
        %+  give-simple-payload:app:server
          eyre-id
          simple-payload
        ?+  method.request.inbound-request  [not-found:gen:server this]
          %'GET'
            ?+  (stab url.request.inbound-request)  [not-found:gen:server this]
              [@ ~]
                :_  this
                =/  c
                  (~(got by components-state) %root)
                (manx-response:gen:server (full-document viw.c bowl))
            ==
        ==
        [cards this]
      %ui
        =/  poke  !<(ui-poke vase)
        ?-  -.poke
          %domevent
                =/  dit=term  target:+>.poke
                ~&  dit
                =/  c  (~(get by components-state) dit)
                ?~  c
                ::::~&  "no component found"
                `this
                =/  mold  (~(get by components) cab.u.c)
                ?~  mold  `this
                =/  bowl  (make-bowl bowl [dit cab.u.c])
                =.  component  u.mold(bowl bowl)
                =^  cards  component  (on-load:og sta.u.c)
                =^  cards  component  (on-poke:og [mark vase])
                =/  new-state  on-save:og
                =/  new-view  (with-id view:og dit)
                =/  view-fact
                  [%give %fact ~[/[dit]/view] [%tape !>((en-xml:html new-view))]]
                =.  components-state
                  (~(put by components-state) dit [cab.u.c new-state new-view pop.u.c sot.u.c])
                =.  cards  (snoc cards view-fact)
                [cards this]
          %new-component
            =/  c  (~(got by components) cab.poke)
            =/  bowl  (make-bowl bowl [dit.poke cab.poke])
            =/  [cards=(list card:agent:gall) this=agent:gall]  on-init(component c(bowl bowl, props pop.poke, children sot.poke))  ::TODO|DONE what do with dit.poke?
            :: =^  cards  this  on-init(component ~(. c [pop.poke *marl bowl]))  ::TODO|DONE what do with dit.poke?
            [cards this]
            :: [~ this]
          %remove-component
            ?.  (~(has by components-state) dit.poke)  `this
            =.  components-state  (~(del by components-state) dit.poke)
            `this
          %forward-subscription
            ~&  "forward-subscription"
            =/  c  (~(got by components-state) dit.poke)
            =/  mold  (~(got by components) cab.c)
            =^  cards  component  (on-load:og sta.c)
            =^  cards  component  (on-agent:og wire.poke sign.poke)
            :: get new state and view
            =/  state  on-save:og
            =/  view  (with-id view:og dit.poke)
            =/  view-fact
              [%give %fact ~[/[dit.poke]/view] [%tape !>((en-xml:html view))]]
            :: update wrapper state
            =.  components-state
              (~(put by components-state) dit.poke [cab.c state view pop.c sot.c])
            =.  cards  (snoc cards view-fact)
            [cards this]
        ==
    ==
  ::
  ++  on-watch
    |=  =path
    :: ~&  "current state is"
    :: ~&  ~(key by components-state)
    :: ~&  "path is"
    :: ~&  path
    :: ~&  "current-manx at on-watch:og"  ~&  current-manx
    ^-  (quip card:agent:gall agent:gall)
    ?+  path    =^  cards  agent  (on-watch:ag path)
                [cards this]
      [%http-response *]  ::NOTE see above note at %handle-http-request
      =^  cards  agent  (on-watch:ag path)
      [cards this]
      ::
      [term %view ~]
        :_  this
        =/  c  (~(got by components-state) -.path)
        :~
          [%give %fact ~ [%tape !>((en-xml:html viw.c))]]
        ==
      [%component *]
        =/  dit  +<.path
        =/  c  (~(got by components-state) dit)
        =/  mold  (~(got by components) cab.c)
        =/  c-bowl  (make-bowl bowl [dit cab.c])
        =.  component  mold(bowl c-bowl, props pop.c, children sot.c)
        =^  cards  component  (on-load:og sta.c)
        =^  cards  component  (on-watch:og +>.path)  ::TODO update component [state view] in wrapper state map
        =/  new-state  on-save:og
        =/  new-view  (with-id view:og dit)
        =/  view-fact
          [%give %fact ~[/[dit]/view] [%tape !>((en-xml:html new-view))]]
        =?  components-state  |(!=(new-view viw.c) !=(new-state sta.c))
          (~(put by components-state) dit [cab.c new-state new-view pop.c sot.c])
        =?  cards  !=(new-view viw.c)
          (snoc cards view-fact)
        [cards this]
    ==
  ::
  ++  on-leave
    |=  =path
    ^-  (quip card:agent:gall agent:gall)
    =^  cards  agent  (on-leave:ag path)
    [cards this]
  ::
  ++  on-peek
    |=  =path
    ^-  (unit (unit cage))
    (on-peek:ag path)
  ::
  ++  on-agent
    |=  [=wire =sign:agent:gall]
    ~&  >  'on-agent-lib'  ~&  wire
    ^-  (quip card:agent:gall agent:gall)
    ?.  ?=([%component term *] wire)
      =^  cards  agent  (on-agent:ag wire sign)
      [cards this]
    =/  dit  +<.wire
    =/  c  (~(got by components-state) dit)
    =/  mold  (~(got by components) cab.c)
    =/  c-bowl  (make-bowl bowl [dit cab.c])
    =.  component  mold(bowl c-bowl, props pop.c, children sot.c)
    =^  cards  component  (on-load:og sta.c)
    =^  cards  component  (on-agent:og +>.wire sign)
    :: get new state and view
    =/  state  on-save:og
    =/  view  (with-id view:og dit)
    =/  view-fact
      [%give %fact ~[/[dit]/view] [%tape !>((en-xml:html view))]]
    =/  flat-new
      %+  skip  ~(lvl-flatten-innertext manx-tools view)
      |=  =manx
      |(?=(html-tag:html-tag n.g.manx) ?=(%$ n.g.manx))
    =/  flat-current
      %+  skip  ~(lvl-flatten-innertext manx-tools viw.c)
      |=  =manx
      |(?=(html-tag:html-tag n.g.manx) ?=(%$ n.g.manx))
    =/  [unique-new=(list manx) unique-current=(list manx)]
      =/  flat-new=(list manx)
          %+  skip  ~(lvl-flatten-innertext-sail-id manx-tools view)
          |=  =manx
          |(?=(html-tag:html-tag n.g.manx) ?=(%$ n.g.manx))
      ::
      =/  flat-current=(list manx)
        %+  skip  ~(lvl-flatten-innertext-sail-id manx-tools viw.c)
        |=  =manx
        |(?=(html-tag:html-tag n.g.manx) ?=(%$ n.g.manx))
      ::
      :-
        %+  turn
          %~  tap  in
            %-  %~  dif  in  (silt flat-new)
              (silt flat-current)
        |=  man=manx
        =+  (skim ^flat-new |=(man=manx =((need (~(get-attr manx-tools *manx) g.man %sail-id)) (need (~(get-attr manx-tools *manx) g.^man %sail-id)))))
        ?~  -  ~&  "not found id from flat-new"  man
        ~&  "found id from flat-new"
        i.-
        ::
          %~  tap  in
            %-  %~  dif  in  (silt flat-current)
              (silt flat-new)
      =/  new-components-list
        %+  turn  unique-new
        |=  =manx
        :: ~&  "unique manx"
        :: ~&  manx
        ^-  [term term (map mane vase) marl]
        :^  ^-  term
            %-  crip
            (need (~(get-attr manx-tools *^manx) g.manx %sail-id))
            ::
            ;;(term n.g.manx)
            ::
          ^-  (map mane vase)
          =.  a.g.manx
            :: (~(del-attrs manx-tools manx) (silt ~[%sail-id %key]))
            %+  skip  a.g.manx
            |=  [attr=mane val=tape]
            |(?=(%sail-id attr) ?=(%key attr) ?=(html-attr:html-attr attr))
            :: ?=(html-attr:html-attr attr)
          %-  ~(run by (malt a.g.manx))
          |=  val=tape
          =+  (slaw %ud (crip val))
          ?~  -  !>(~)
          !>((cue u.-))
            ::
            c.manx
      =/  to-be-removed-components-list
        %+  turn  unique-current
        |=  =manx
        ^-  term
        %-  crip
          (need (~(get-attr manx-tools *^manx) g.manx %sail-id))
    =/  new-component-cards
      %+  turn  new-components-list
        |=  [dit=term cab=term pop=(map mane vase) sot=marl]
        ^-  card:agent:gall
        [%pass /new-component %agent [our.bowl dap.bowl] %poke [%ui !>([%new-component [dit cab pop sot]])]]
    =/  remove-component-cards
      %+  turn  to-be-removed-components-list
        |=  dit=term
        ~&  "nuke-agent"
        ~&  dit
        ^-  card:agent:gall
        :*  %pass  /nuke-component  %agent  [our.bowl dap.bowl]
          %poke  %ui  !>([%remove-component dit])
        ==
    =.  cards  :(weld new-component-cards remove-component-cards cards)
    =.  cards  (snoc cards view-fact)
    :: update wrapper state
    =.  components-state
      (~(put by components-state) dit [cab.c state view pop.c sot.c])
    [cards this]
    ::
    ++  on-arvo
    |=  [=wire =sign-arvo]
    ^-  (quip card:agent:gall agent:gall)
    :: ?:  =(wire /start-agent)  `this
    =^  cards  agent  (on-arvo:ag wire sign-arvo)
    [cards this]
  ::
    ++  on-fail
    |=  [=term =tang]
    ^-  (quip card:agent:gall agent:gall)
    =^  cards  agent  (on-fail:ag term tang)
    [cards this]
  --
--