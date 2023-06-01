/-  html-tag
/+  default-agent, server, agentio, manx-tools, ui2

|%
++  card  card:agent:gall
::
+$  eyre-id  @ta
::
+$  wrapper-state
  $:  current-manx=manx
  ==
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
    (slav %ud (crip u.key))
    :: :(mul (mug n.marx) p s)
  =.  a.marx
  (snoc a.marx [%sail-id (weld "c" (a-co:co id))])
  marx
::
++  with-id
  |=  =manx
  ^-  ^manx
  (apply-elem manx 0 0 generate-id)
++  with-id-merge
  |=  [new=manx current=manx]
  ^-  manx
  %+  merge-manx:hc:ui2  current
  (apply-elem new 0 0 generate-id)
++  component-div-tag
  |=  =manx
  =/  gate
    |=  =marx
    ?:  |(?=(html-tag:html-tag n.marx) ?=(%$ n.marx))  marx
    marx(n %div)
  (~(apply-elem manx-tools manx) gate)
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
          //delete element;
          return
      } else \{
        //element.innerHTML = ''
      innerHTML(element, e)
      //release(element);
      //delete element;
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

  function eventPoke(listener, event) \{
          //console.log('event-poke', listener, event.target, event.currentTarget)
          api.poke(\{
              app: target(event),
              mark: "ui",
              json: \{domevent:\{[listener]:createListenerObject(listener, event)}},
              onSuccess: () => console.log('Success poke'),
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
                      eventPoke(event, e)
                      console.log('event-poke', event, e.target, e.currentTarget)
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
              listeners.forEach((listener) => \{
                  //console.log('adding event listener to eventListeners map', listener)
                  if (eventListeners.has(listener)) \{
                    // push the domEl sail-id to the array of sail-ids for this listener
                      eventListeners.get(listener).push(domEl.getAttribute('sail-id'))
                      //delete domEl
                  } else \{
                      eventListeners.set(listener, [domEl.getAttribute('sail-id')])
                      //delete domEl
                  }
              })
          }
          else \{
              console.log('domEl not found', `[sail-id='$\{Object.keys(el)[0]}']`)
              queue.push(el)
              //delete domEl
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
            })
        
        });
        // update components
        components = newComponents;
        // subscribe to new components
        diff.forEach((component) => \{
            console.log('subscribing to', component)
            api.subscribe(\{
                  app: component,
                  path: "/event-listeners",
                  event: addEventListeners,
                  quit: () => kick(component),
                  err: () => console.log('Error')
                });
        });

        diff.forEach((component) => \{
            api.subscribe(\{
                  app: component,
                  path: "/view",
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
          app: component,
          path: "/event-listeners",
          event: addEventListeners,
          quit: () => kick(component),
          err: () => console.log('Error')
        });
  });   

  components.forEach((component) => \{
    api.subscribe(\{
          app: component,
          path: "/view",
          event: (e) => doMorph(e, component),
          quit: () => kick(component),
          err: () => console.log('Error')
        });
  });
  """
  --
++  web-component
  $_  ^|
  |_  [children=marl bowl:gall]
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
:: ++  hc
:: |_  [=bowl:gall =components=(map term agent:gall) ]
++  agent
  |=  components=(map term $-((unit vase) agent:gall))
  |=  component=web-component
  =|  wrapper-state
  =*  wrapper-state  -
  :: ~&  (turn ~(tap by components) |=([dap=term =agent:gall] [%pass /start-agent %arvo %g [%jole %base dap !>(agent)]]))
  ^-  agent:gall
  |_  =bowl:gall
  +*  this  .
      og    ~(. component [*marl bowl])
      :: hc    ~(. ^hc [bowl components og])
  ::
  ++  on-init
    ^-  (quip card:agent:gall agent:gall)
    =^  cards  component  on-init:og
    :: run through view:og and for each marx that corresponds to a sail-component,
    :: send a card to gall to start agent for that sail-component
    =/  flat-manx=(list manx)  ~(lvl-flatten-innertext manx-tools (with-id view:og))
    =.  flat-manx
      %+  skip  flat-manx
      |=  =manx
      |(?=(html-tag:html-tag n.g.manx) ?=(%$ n.g.manx))
    =/  components-list
      %+  turn  `(list manx)`flat-manx
      |=  =manx
      ~&  manx
      ^-  [term agent:gall]
      :-  ^-  term
          %-  crip
          (need (~(get-attr manx-tools *^manx) g.manx %sail-id))
          ::
          =/  props
            (~(get-attr manx-tools *^manx) g.manx %props)
          ?~  props
            %.  ~
            (~(got by components) ;;(term n.g.manx))
          %.  `!>((cue (slav %ud (crip u.props))))
          (~(got by components) ;;(term n.g.manx))
    =/  start-agent-cards
      %+  turn  components-list
        |=  [dap=term =agent:gall]
        ^-  card:agent:gall
        [%pass /start-agent %arvo %g [%jole q.byk.bowl dap !>(agent)]]
    =.  cards  (weld start-agent-cards cards)
    :: [cards this(current-manx (component-div-tag (with-id view:og)))]
    [cards this(current-manx (with-id view:og))]
  ::
  ++  on-save  !>([[%ui-wrapper wrapper-state] on-save:og])
  ::
    ++  on-load
    |=  ole=vase
    :: ::::~&  sail
    ^-  (quip card:agent:gall agent:gall)
    ?.  ?=([[%ui-wrapper *] *] q.ole)
    =^  cards   component   (on-load:og ole)
      [cards this]
    =+  !<([[%ui-wrapper old=^wrapper-state] ile=vase] ole)
    :: ::::~&  q.ile
    =^  cards  component  (on-load:og ile)
    [cards this(wrapper-state old)]
  ::
  ++  on-poke
    |=  [=mark =vase]
    ^-  (quip card:agent:gall agent:gall)
    ?.  ?=(%handle-http-request mark)
      =^  cards  component  (on-poke:og mark vase)
    =/  new-view
      :: (component-div-tag (with-id view:og))
      (with-id view:og)
      :: ~&  "new-view"
    :: ~&  new-view
    =/  view-fact
      [%give %fact ~[/view] [%tape !>((en-xml:html new-view))]]
    =.  cards  (snoc cards view-fact)
      :: [cards this]
    [cards this(current-manx new-view)]

  ::
    ?-  mark
        %handle-http-request
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
                    :: =/  view=manx  view:og
                    :: ?.  ?=(%root n.g.view)  (manx-response:gen:server ;p:"please wrap app root in ;root;")  ::TODO write a wrapper for this
                    (manx-response:gen:server (full-document current-manx bowl))
                ==
        ==
      [cards this]
    ==
  ::
  ++  on-watch
    |=  =path
    :: ~&  "current-manx at on-watch:og"  ~&  current-manx
    ^-  (quip card:agent:gall agent:gall)
    ?+  path    =^  cards  component  (on-watch:og path)
                [cards this]
      [%http-response *]  [~ this]
      ::
      [%view ~]
      :_  this
      :~
        [%give %fact ~ [%tape !>((en-xml:html current-manx))]]
      ==
    ==
  ::
  ++  on-leave
    |=  =path
    ^-  (quip card:agent:gall agent:gall)
    =^  cards  component  (on-leave:og path)
    [cards this]
  ::
    ++  on-peek
    |=  =path
    ^-  (unit (unit cage))
    (on-peek:og path)
  ::
    ++  on-agent
    |=  [=wire =sign:agent:gall]
    :: ~&  >  'on-agent-lib'  ~&  wire
    ^-  (quip card:agent:gall agent:gall)
    =^  cards  component  (on-agent:og wire sign)
    =/  new-view
      (with-id view:og)
    ~&  >  "view:og"  ~&  view:og
    ~&  >  "new-view"  ~&  new-view
    ~&  >  "current-manx"  ~&  current-manx
    ?:  =(new-view current-manx)  ~&  "views same"  [cards this]
    ~&  "current manx different from new view"
    =/  flat-new
      %+  skip  ~(lvl-flatten-innertext manx-tools new-view)
      |=  =manx
      |(?=(html-tag:html-tag n.g.manx) ?=(%$ n.g.manx))
    =/  flat-current
      %+  skip  ~(lvl-flatten-innertext manx-tools current-manx)
      |=  =manx
      |(?=(html-tag:html-tag n.g.manx) ?=(%$ n.g.manx))
    =/  [unique-new=(list manx) unique-current=(list manx)]
      =/  flat-new=(list manx)
          %+  skip  ~(lvl-flatten-innertext-sail-id manx-tools new-view)
          |=  =manx
          |(?=(html-tag:html-tag n.g.manx) ?=(%$ n.g.manx))
      ::
      =/  flat-current=(list manx)
        %+  skip  ~(lvl-flatten-innertext-sail-id manx-tools current-manx)
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
        ~&  "unique manx"
        ~&  manx
        ^-  [term agent:gall]
        :-  ^-  term
            %-  crip
            (need (~(get-attr manx-tools *^manx) g.manx %sail-id))
            ::
            =/  props
              (~(get-attr manx-tools *^manx) g.manx %props)
            ?~  props
              %.  ~
              (~(got by components) ;;(term n.g.manx))
            %.  `!>((cue (slav %ud (crip u.props))))
            (~(got by components) ;;(term n.g.manx))
      =/  to-be-removed-components-list
        %+  turn  unique-current
        |=  =manx
        ^-  term
        %-  crip
          (need (~(get-attr manx-tools *^manx) g.manx %sail-id))
    =/  start-agent-cards
      %+  turn  new-components-list
        |=  [dap=term =agent:gall]
        ^-  card:agent:gall
        [%pass /start-agent %arvo %g [%jole q.byk.bowl dap !>(agent)]]
    =/  nuke-agent-cards
      %+  turn  to-be-removed-components-list
        |=  dap=term
        ~&  "nuke-agent"
        ~&  dap
        ^-  card:agent:gall
        :*  %pass  /nuke-agent  %agent  [our.bowl %hood]
          %poke  %kiln-nuke  !>([dap %|])
        ==
    =.  cards  :(weld start-agent-cards nuke-agent-cards cards)
    =/  view-fact
      [%give %fact ~[/view] [%tape !>((en-xml:html new-view))]]
    =.  cards  (snoc cards view-fact)
    :: [cards this(current-manx (component-div-tag new-view))]
    [cards this(current-manx (with-id view:og))]
  ::
    ++  on-arvo
    |=  [=wire =sign-arvo]
    ^-  (quip card:agent:gall agent:gall)
    ?:  =(wire /start-agent)  `this
    =^  cards  component  (on-arvo:og wire sign-arvo)
    [cards this]
  ::
    ++  on-fail
    |=  [=term =tang]
    ^-  (quip card:agent:gall agent:gall)
    =^  cards  component  (on-fail:og term tang)
    [cards this]
  --
--