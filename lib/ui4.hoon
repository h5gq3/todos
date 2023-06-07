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
      url-path=path
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
  |=  [=bowl:gall [dit=term cab=term url-path=path]]
  ^-  ^bowl
  [dit cab url-path bowl]
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
  |=  web=flag
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
  ?.  web  marx
  marx(n %div)
::
++  with-id
  |=  [=manx dit=term web=flag]
  ^-  ^manx
  (apply-elem manx (mug dit) 0 (generate-id web))
::
++  make-path
  |=  =binding:eyre
  ?~  site.binding  (trip (spat path.binding))
  %+  weld  (trip u.site.binding)
  (trip (spat path.binding))
::
++  make-div-tagged
  |=  =marx  ^-  ^marx
  ?:  ?=(%$ n.marx)  marx
  ?:  ?=(html-tag:html-tag n.marx)  marx
  marx(n %div)
++  div-tagged
  |=  =manx
  ^-  ^manx
  (~(apply-elem manx-tools manx) make-div-tagged)
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
  |=  [view=manx =bowl:gall binding=tape]
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
  ::TODO|DONE
  :: rootPath is wrong atm - we need to get the path that eyre actually binds
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

  const rootPath = "{binding}";

  var skipOnnavigate;

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

  // when URL is "http://localhost/todos/active" and rootPath is "/todos" we want to return "/active"
  // when URL is "http://localhost/todos" and rootPath is "/todos" we want to return "/"
  // without the "http://localhost" part
  function getRelativePath(url) \{
    let path = url.slice(url.indexOf(rootPath) + rootPath.length);
    if (path === '') \{
      return '/';
    }
    return path;
  }
  



  window.navigation.onnavigate = (e) => \{
    console.log('onnavigate', e);
    if (skipOnnavigate) \{
      skipOnnavigate = false;
      return;
    }
    else \{
      navigationPoke(getRelativePath(e.destination.url));
    }
  }


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

  function navigationPoke(path) \{
          //console.log('navigationPoke', path)
          api.poke(\{
              app: "{(trip dap.bowl)}",
              mark: "ui",
              json: \{'new-path':path},
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
        //let old = getUniqueElements(newComponents, components);
        // unsubscribe from old components
        //old.forEach((component) => \{
        //    console.log('unsubscribing from', component)
        //    release(document.querySelector(`[sail-id='$\{component}']`));
        //    // remove from eventListeners map
        //    eventListeners.forEach((value, key) => \{
        //        if (value.includes(component)) \{
        //            eventListeners.set(key, value.filter((el) => el !== component))
        //        }
        //    eventToggles.delete(component)
        //    })
        //
        //});
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

  function handleNavigation(e) \{
    console.log('handleNavigation', e)
    // use history api to update url
    let path = e === '/' ? rootPath : rootPath + e;
    skipOnnavigate = true;
    history.pushState(\{}, '', path);
  }

  // subscribe to navigation events
  api.subscribe(\{
          app: "{(trip dap.bowl)}",
          path: '/new-url-path',
          event: (e) => handleNavigation(e),
          quit: () => console.log('quit'),
          err: () => console.log('Error')
        });
  """
--
::
++  agent
  |=  [[component=web-component =components] =agent:gall]
  =|  ag-init=flag
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
    ::  all subsequent calls to this on-init will come from this on-poke (.ag-init is |)
    ::  these calls initialize new components and put their produced manx and state to wrapper state map
    ::
    ::  check if root view is in state
    ::  if not, this means we're at initial agent on-init and need to put root view to state
    =^  cards  agent
      ?.  ag-init  `agent
      on-init:ag
    ::  if initial agent on-init, we get the eyre binding from cards
    =?  eyre-binding  ag-init
      =-  (make-path -)
      ^-  binding:eyre
      =/  eyre-card
        %+  skim  cards
        |=  =card:agent:gall
        ?=([%pass ^ %arvo %e %connect *] card)
      ?~  eyre-card  *binding:eyre
      =/  card  i.eyre-card
      ?>  ?=([%pass ^ %arvo %e %connect *] card)
      binding.q.card
    ::  if initial agent on-init, put root view mold to components
    =?  components  ag-init
      (~(put by components) [%root component])
    =/  dit
      ?:  ag-init  %root  dit.bowl.cs
    =/  cab
      ?:  ag-init  %root  cab.bowl.cs
    ?:  (~(has by components-state) dit)
    :: ~&  "has by components-state"
    :: ~&  dit
    [cards this]
    =^  og-cards  component  on-init:og
    =/  state  on-save:og
    =/  view  (with-id view:og dit |)
    ::     ~&  "put by components-state"
    :: ~&  dit
    :: ~&  cab
    :: ~&  props.cs
    :: ~&  children.cs
    =.  components-state
      (~(put by components-state) dit [cab state view props.cs children.cs])
    =/  flat-manx=(list manx)  ~(lvl-flatten-innertext manx-tools view)
    =.  flat-manx
      %+  skip  flat-manx
      |=  =manx
      |(?=(html-tag:html-tag n.g.manx) ?=(%$ n.g.manx))
    :: ~&  "flat-manx"
    :: ~&  flat-manx
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
        :: ~&  "new-component-cards"
        :: ~&  dit
        :: ~&  cab
        :: ~&  pop
        :: [%pass /start-agent %arvo %g [%jole q.byk.bowl dap !>(agent)]]
        [%pass /new-component %agent [our.bowl dap.bowl] %poke [%ui !>([%new-component [dit cab pop sot]])]]
    :: ~&  "dit at watch-path-change-card"
    :: ~&  dit
    =/  watch-path-change=card:agent:gall
      [%pass /component/[dit]/new-url-path %agent [our.bowl dap.bowl] %watch /new-url-path]
    =.  cards  :(weld new-component-cards og-cards cards)
    =.  cards  (snoc cards watch-path-change)
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
        =^  cards  this
        =+  !<([=eyre-id =inbound-request:eyre] vase)
        =/  path  (stab url.request.inbound-request)
        =/  navigation-card
          [%pass /navigation-poke %agent [our.bowl dap.bowl] %poke [%ui !>([%new-path +.path])]]
        =/  c
          (~(got by components-state) %root)
        =/  document
          (manx-response:gen:server (full-document (div-tagged viw.c) bowl eyre-binding))
        =;  [=simple-payload:http =_this]
        =/  payload-cards
          %+  give-simple-payload:app:server
          eyre-id
          simple-payload
        :_  this
        %+  snoc  payload-cards
          navigation-card
        ?+  method.request.inbound-request  [not-found:gen:server this]
          %'GET'
            ?+  path  [document this]
                [@ ~]
              [document this]
            ==
        ==
        [cards this]
      %ui
        =/  poke  !<(ui-poke vase)
        ?-  -.poke
          %domevent
                =/  dit=term  target:+>.poke
                :: ~&  dit
                =/  c  (~(get by components-state) dit)
                ?~  c
                ::::~&  "no component found"
                `this
                =/  mold  (~(get by components) cab.u.c)
                ?~  mold  `this
                =/  bowl  (make-bowl bowl [dit cab.u.c url-path])
                =.  component  u.mold(bowl bowl, props pop.u.c, children sot.u.c)
                =^  cards  component  (on-load:og sta.u.c)
                =^  cards  component  (on-poke:og [mark vase])
                =/  new-state  on-save:og
                =/  new-view  (with-id view:og dit |)
                =/  web-view  (with-id view:og dit &)
                =/  view-fact
                  [%give %fact ~[/[dit]/view] [%tape !>((en-xml:html web-view))]]
                =.  components-state
                  (~(put by components-state) dit [cab.u.c new-state new-view pop.u.c sot.u.c])
                =.  cards  (snoc cards view-fact)
                [cards this]
          %new-component
            =/  c  (~(got by components) cab.poke)
            =/  bowl  (make-bowl bowl [dit.poke cab.poke url-path])
            =/  [cards=(list card:agent:gall) this=agent:gall]  on-init(ag-init |, component c(bowl bowl, props pop.poke, children sot.poke))  ::TODO|DONE what do with dit.poke?
            [cards this]
            :: [~ this]
          %remove-component
            ?.  (~(has by components-state) dit.poke)  `this
            =.  components-state  (~(del by components-state) dit.poke)
            `this
          %forward-subscription
            :: ~&  "forward-subscription"
            =/  c  (~(got by components-state) dit.poke)
            =/  mold  (~(got by components) cab.c)
            =^  cards  component  (on-load:og sta.c)
            =^  cards  component  (on-agent:og wire.poke sign.poke)
            :: get new state and view
            =/  state  on-save:og
            =/  view  (with-id view:og dit.poke &)
            =/  view-fact
              [%give %fact ~[/[dit.poke]/view] [%tape !>((en-xml:html view))]]
            :: update wrapper state
            =.  components-state
              (~(put by components-state) dit.poke [cab.c state view pop.c sot.c])
            =.  cards  (snoc cards view-fact)
            [cards this]
          %new-path
          ~&  >  'new-path'
          ~&  path.poke
          ?:  =(path.poke url-path)  `this
          =/  card
            [%give %fact ~[/new-url-path] [%path !>(path.poke)]]
          =?  url-path  !=(path.poke url-path)
            path.poke
          [[card]~ this]
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
      [%http-response *]  [~ this]  ::TODO what if ag does http stuff too?
      ::
      [term %view ~]
        :_  this
        =/  c  (~(got by components-state) -.path)
        :~
          [%give %fact ~ [%tape !>((en-xml:html (div-tagged viw.c)))]]  ::TODO web viw.c
        ==
      [%new-url-path ~]  `this
      [%component *]
        =/  dit  +<.path
        =/  c  (~(got by components-state) dit)
        =/  mold  (~(got by components) cab.c)
        =/  c-bowl  (make-bowl bowl [dit cab.c url-path])
        =.  component  mold(bowl c-bowl, props pop.c, children sot.c)
        =^  cards  component  (on-load:og sta.c)
        =^  cards  component  (on-watch:og +>.path)  ::TODO update component [state view] in wrapper state map
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
    :: ~&  >  'on-agent-lib'  ~&  wire
    ^-  (quip card:agent:gall agent:gall)
    ?.  ?=([%component term *] wire)
      =^  cards  agent  (on-agent:ag wire sign)
      [cards this]
    ?.  ?=(%fact -.sign)
    ~&  "not a fact"
    `this
    =/  dit  +<.wire
    =/  c  (~(got by components-state) dit)
    =/  mold  (~(got by components) cab.c)
    =/  c-bowl  (make-bowl bowl [dit cab.c url-path])
    =.  component  mold(bowl c-bowl, props pop.c, children sot.c)
    =^  cards  component  (on-load:og sta.c)
    =^  cards  component
    ::  if wire is %new-url-path we handle it here, otherwise we pass sign to the component
    ?:  ?=([%component term %new-url-path ~] wire)
      :: ~&  "new-url-path wire"
      [cards component]
    (on-agent:og +>.wire sign)
    :: get new state and view
    =/  state  on-save:og
    =/  view-web  (with-id view:og dit &)
    =/  view  (with-id view:og dit |)
    :: ~&  wire
    :: ~&  view
    :: ~&  viw.c
    ::  if views and state are same we don't update or send new view to FE
    ?:  &(=(state sta.c) =(view viw.c))
      :: ~&  "state and view same, not updating"
      `this
    =/  view-fact
      [%give %fact ~[/[dit]/view] [%tape !>((en-xml:html view-web))]]
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
        :: ~&  "found id from flat-new"
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
      ::  if wire is %new-url-path we don't delete components from state
      ?:  ?=([%component term %new-url-path ~] wire)  ~
      %+  turn  to-be-removed-components-list
        |=  dit=term
        :: ~&  "nuke-agent"
        :: ~&  dit
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