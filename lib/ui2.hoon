::  ui framework
::
::  used as wrapper around an agent (app's controller)
::  usage: %-(agent:ui your-agent sail-template)
::
/-  html-tag
/+  default-agent, server, agentio, manx-tools
:: /*  test  %urb  /lib/test2/urb

|%
+$  wrapper-state
  $:  =nid-map
      components-state=component-instances
      dom-event-listeners=(list [@t (list term)])
      current-manx=manx
  ==
::
+$  sail-bowl
  $:  =bowl:gall
      this=tape
      ref=(unit tape)
  ==
::TODO components map contains the molds of components
:: but we must also store another map of components that get initialized from the parent map
:: otherwise we couldn't store multiple instances of a component
:: +$  inited-components  (map @ta sail-component)
+$  components  (map @ta sail-component)  ::TODO rename to component-molds
+$  component-instances  (map tape [sail-component vase]) :: vase is the props vase passed to the component
++  sail-component
  $_  ^|
  |_  [props=vase children=marl sail-bowl]
  ++  on-init  *(quip card:agent:gall _^|(..on-init))
  ++  on-poke  |~([mark vase] *(quip card:agent:gall _^|(..on-init)))
  ++  manx  *^manx  ::TODO attach id to each component root div and tag it with .sail-component class
  --
::
:: ++  sail-component
::   :-  state=vase
::       =manx
++  s
  |=  a=*
  ^-  tape
  <(jam a)>
::
+$  eyre-id  @ta
::
+$  nid-map  (map @ta @ud)
::
:: ++  ids  :: component ids to nid-map
::
++  transform-manx
    ~&  "transform-manx took"
    ~>  %bout
  |=  [sail=manx components=component-instances ag-state=vase =bowl:gall]
  |%
  ++  abet
    ^-  manx
    (xray-to-manx sail)
  ::
  ++  xray-to-manx
    |=  =manx  ^-  ^manx
    :: ~&  manx
    |^

    ?:  ?=(%$ n.g.manx)  manx
    ?:  ?=(%root n.g.manx)  [`marx`g:`^manx`;div.root; (cloop c.manx)]
    ?:  ?=(html-tag:html-tag n.g.manx)  [g.manx (cloop c.manx)]
    :: =/  cname  "%{(trip ;;(@tas n.g.manx))}"
    :: =/  cid  "{(~(get-attr manx-tools *^manx) g.manx %sail-id)}"
    :: =/  cname  ;;(@tas n.g.manx)
    :: ::~&  "manx at recursion"
    :: ::~&  manx
    =/  cid  (~(get-attr manx-tools *^manx) g.manx %sail-id)
    =/  ref  (~(get-attr manx-tools *^manx) g.manx %ref)
    :: ::~&  "cid"
    :: ::~&  cid
    :: =/  props
    ::   ?:  =((need cid) "root")  ag-state
    ::   :: (~(get-attr manx-tools *^manx) g.manx %props)
    ::   +:(~(got by components) (need cid))
    =/  new-prop-vase
      ?:  =((need cid) "root")  ag-state
              =/  prop-tape
                (~(get-attr manx-tools *^manx) g.manx %props)
              ?~  prop-tape
              :: ::::~&  (need cid)
              :: ::::~&  (~(has by components) (need cid))
                +:(~(got by components) (need cid))
              !>((cue (slav %ud (crip u.prop-tape))))
    ::TODO need to pass attributes to component
    :: =/  rm  (crip "~(manx (~(got by components) [\"{cid}\" {cname}]) ((swat |.(state=state) (ream '[{(reduce-sample manx)}]'))) bowl)")
    :: ::::~&  rm
    :: ::::~&  sail
    :: ::::~&  !<(smanx=^manx ((swat |.(!>([state=ag-state components=components manx=manx bowl=bowl ..zuse])) (ream rm))))
    :: =+  !<(smanx=^manx ((swat |.(!>([state=ag-state components=components manx=manx bowl=bowl ..zuse])) (ream rm))))
    =/  smanx
      ~(manx (~(got by components) (need cid)) [new-prop-vase c.manx [bowl (need cid) ref]])
    :: ::~&  "smanx from {<;;(@tas n.g.manx)>} is"
    :: ::~&  smanx
    :: ::~&  "previous manx was"
    :: ::~&  ~(manx (~(got by components) (need cid)) [+:(~(got by components) (need cid)) c.manx [bowl (need cid) ref]])
    ?:  ?=(html-tag:html-tag n.g.manx)
      [g.smanx (cloop c.manx)]
    :: ::::~&  "not html tag, recurse"
    $(manx [g.smanx c.smanx])
    ::
    ++  cloop
      |=  c=marl
      :: ::::~&  c
      ?~  c  ~
      ?>  ?=([^ *] i.c)
      [^$(manx i.c) (cloop t.c)]
    --
  --
--
::
=|  wrapper-state
=*  wrapper-state  -
::  dom node id mapped to sail-component key @ta in .components
::  how do i initialize this map? on on-init? i'd need to process the sail to generate this map
:: =/  nid-map  (~(put by *(map @t @ta)) 'i1' ~.random-number)

:: =|  components-state=components

|%
+$  ui-poke
  $%  [%domevent dom-event]
  ==
+$  dom-event
  $%  [%click click-event]
      [%keydown key-down-event]
      [%mouseenter mouse-enter-event]
      [%mouseleave mouse-leave-event]
  ==
+$  click-event
  $:  target=cord
      target-id=(unit cord)
  ==
+$  key-down-event
  $:  target=cord
      key=cord
      target-id=(unit cord)
  ==
+$  mouse-enter-event
  $:  target=cord
      target-id=(unit cord)
  ==
+$  mouse-leave-event
  $:  target=cord
      target-id=(unit cord)
  ==

::
++  json-to-poke
  =,  dejs:format
  |^
  %-  of
  :~  domevent+dom-event
  ==
  ++  dom-event
  %-  of
  :~  click+click-event
      keydown+key-down-event
      mouseenter+mouse-enter-event
      mouseleave+mouse-leave-event
  ==
  ++  click-event
    %-  ot
  :~
    [%target so]
    [%target-id so:dejs-soft]
  ==
  ++  key-down-event
    %-  ot
  :~
    [%target so]
    [%key so]
    [%target-id so:dejs-soft]
  ==
  ++  mouse-enter-event
    %-  ot
  :~
    [%target so]
    [%target-id so:dejs-soft]
  ==
  ++  mouse-leave-event
    %-  ot
  :~
    [%target so]
    [%target-id so:dejs-soft]
  ==
  --
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
::
++  page-cor
|_  [components=component-instances ag-state=vase =bowl:gall]
++  page
  |=  sail=manx
  :: ::::~&  !<(@ ag-state)
  :: |=  sail=cord
  =/  routes
    :~
    /home
    /todos
    ==
  |%
  ++  full
    :: add "hidden" to prevent FOUC (flash of unstyled content), twind will remove it
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
        ;+  in-body
        ==
  ++  in-body
    :: ~&  abet:(transform-manx [sail components ag-state bowl])
    abet:(transform-manx [sail components ag-state bowl])
  --
++  onclick
"""
((event) => \{
event.stopPropagation();
window.api.poke(\{
app: "{(trip dap.bowl)}",
mark: "noun",
json: \{domevent:\{click:\{target:event.target.id}}},
onSuccess: () => void,
onError: () => void
})})(event)
"""
++  onclicksub
"""
window.id = window.api.subscribe(\{
        app: "{(trip dap.bowl)}",
        path: "/morph",
        event: (e) => window.morphdom(document.body, e),
        quit: () => console.log('kicked'),
        err: () => console.log('Error')
      });
"""
:: ++  routable
::   |=  =route
::   ^-  manx
::   ?+  route  ;div;
::     %maailm  ;p: tere maailm
::     %aap  ;p: tere aap
::     %world  ;p: hello world
::     ==
++  script
"""
import Urbit from 'https://cdn.skypack.dev/@urbit/http-api';

import \{ innerHTML, use } from 'https://cdn.skypack.dev/diffhtml';

import \{ setup, disconnect } from 'https://cdn.skypack.dev/twind/shim'

// create a queue to store tasks that need to be run after the render transaction
var queue = [];

// create a map `listener -> [sail-id]` to store sail-ids that need to be poked
var eventListeners = new Map();


window.ship = "{(oust [0 1] "{<our.bowl>}")}";
const api = new Urbit("");
window.api = api
api.ship = window.ship;
api.poke(\{
app: "hood",
mark: "helm-hi",
json: "hei",
onSuccess: () => console.log('Success'),
onError: () => console.log('Error')
});

const doMorph = (e) => \{
    //console.log(document.documentElement.querySelector('#container'), e); // document not null    
    innerHTML(document.body, e)
}



const target = (event) => \{
    if (event.target.getAttribute('ref')) \{
        return event.target.getAttribute('ref')
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
            app: "{(trip dap.bowl)}",
            mark: "ui",
            json: \{domevent:\{[listener]:createListenerObject(listener, event)}},
            onSuccess: () => console.log('Success poke'),
            onError: () => console.log('Error poke')
        })
}

// add listeners to document

['click', 'keydown', 'mouseenter', 'mouseleave'].forEach((event) => \{
    document.addEventListener(event, (e) => \{
        //console.log(e.target.getAttribute('ref'), e.target.getAttribute('sail-id'))
        //console.log('event', event, e.target, eventListeners)
        if (e.target.getAttribute) \{
        if (e.target.getAttribute('ref') || e.target.getAttribute('sail-id')) \{
            if (eventListeners.has(event)) \{
                if (eventListeners.get(event).includes(e.target.getAttribute('ref')) || eventListeners.get(event).includes(e.target.getAttribute('sail-id'))) \{
                    eventPoke(event, e)
                    console.log('event-poke', event, e.target, e.currentTarget)
                }
            }
        }
        }
    }, true)
})

const addEventListeners = (e) => \{
    //console.log('addEventListeners', e)
    e.forEach((el) => \{
        const domEl = document.querySelector(`[sail-id='$\{Object.keys(el)[0]}']`)
        const listeners = Object.values(el)[0]
        if (domEl) \{
            //console.log('adding event listener to domEl', domEl)
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
            //console.log('domEl not found', `[sail-id='$\{Object.keys(el)[0]}']`)
            queue.push(el)
        }
    })
}

function someTask(transaction) \{
  //console.log('Start of render transaction:', transaction);

  return () => \{
    console.log('End of render transaction scheduled');
    console.log('state', transaction.state);

    transaction.onceEnded(() => \{
      //console.log('End of render transaction completed');
      // run queued addEventListener tasks
      addEventListeners(queue);
      queue = [];
    });
  };
}

use(someTask);

// TODO: add a way to unsubscribe
window.id = api.subscribe(\{
        app: "{(trip dap.bowl)}",
        path: "/morph",
        event: doMorph,
        quit: () => console.log('kicked'),
        err: () => console.log('Error')
      });

window.id = api.subscribe(\{
        app: "{(trip dap.bowl)}",
        path: "/event-listeners",
        event: addEventListeners,
        quit: () => console.log('kicked'),
        err: () => console.log('Error')
      });
"""
--
::
::
::
++  agent
  |=  [ui=[=components root=sail-component] =agent:gall]  ::TODO ui should be a sail-component
  :: |=  [[=components sail=$-(components hoon)] =agent:gall]
  ^-  agent:gall
  |_  =bowl:gall
  +*  this  .
      ag    ~(. agent bowl)
      hc    ~(. ^hc [ui agent bowl])
      :: ag-state    ?@(`*`q:on-save:ag on-save:ag vase:!<([[%ui-wrapper ^wrapper-state] =vase] on-save:ag))
      ag-state    on-save:ag
      pg
    ::       ~&  "pg took"
    :: ~>  %bout
      (~(page page-cor [components-state ag-state bowl]) ~(manx (~(got by components-state) "root") [ag-state ~ [bowl "root" ~]]))
      io    ~(. agentio bowl)
      morph-fact
    ::             ~&  "morph-fact took"
    :: ~>  %bout
      (fact:io [%tape !>((en-xml:html in-body:pg))] ~[/morph])
  ::
  ++  on-poke
    :: ~&  "on-poke took"
    :: ~>  %bout
    |=  [=mark =vase]
    :: ::::~&  ag-state
    ^-  (quip card:agent:gall agent:gall)
    ?.  ?=(?(%ui %handle-http-request) mark)  ::TODO  i might be able to remove this check
        =^  cards  agent  (on-poke:ag mark vase)  :: weld morph card to make sure we get updated ui when changes occur in inner core
        :: manx tree shape might change when we get new state from inner core
        :: so we need to update the components-state
            ~&  "image-to-instance took"
    ~>  %bout
        =+  update=(image-to-instance:hc ~(manx (~(got by components-state) "root") [ag-state ~ [bowl "root" ~]]) |)
        =^  c-cards  components-state  -.update
        =.  nid-map  +.update
        :: ~&  "nid-map"
        :: ~&  nid-map
        
        ::~&  "c-cards"
        ::~&  c-cards
        =/  event-listeners-cards=(list card:agent:gall)
        %+  skim
          c-cards
        |=  =card:agent:gall
        ^-  ?
        ?=([%give [%fact [* [%domevents *]]]] card)

      =/  event-listeners=(list [@t (list term)])
        %+  turn
          event-listeners-cards
        |=  =card:agent:gall
        ^-  [@t (list term)]
        ?>  ?=(%give -.card)
        ?>  ?=(%fact +<.card)
        =+  !<(listeners=[@t (list term)] +>+>.card)
        listeners
      =/  skimmed
        %+  skim
          (weld dom-event-listeners event-listeners)
        |=  [id=@t (list term)]
        (~(has by components-state) (trip id))
            [:(weld cards c-cards ~[morph-fact]) this(dom-event-listeners skimmed)]  ::TODO check if state changed before sending morph-fact
    ?-  mark
    %handle-http-request  ::TODO  make possible to %handle-http-request in ag too?
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
                    (manx-response:gen:server full:pg)
                ==
        ==
      [cards this]
    %ui
    =/  poke  !<(ui-poke vase)
    :: ::::~&  poke
    ?-  -.poke
      %domevent
        ?-  +<.poke
          %click
            =/  cid  (trip target:+>.poke)
            :: ::::~&  "cid at click"
            :: ::::~&  cid
            =/  c  (~(get by components-state) cid)
            ?~  c
            ::::~&  "no component found"
            `this
            =/  root-c  (~(got by components-state) "root")
            =/  root-manx  ~(manx -:root-c ag-state ~ [bowl "root" ~])
            ::TODO need to flatten only the subtree of the component that received the event
            ::TODO don't flatten children that are inner text
            =/  flattened  ~(lvl-flatten-innertext manx-tools root-manx)
            =/  acc  flattened
            ::  recurse through flattened tree and flatten nodes that resolve to sail-components, then weld to flattened
            =.  acc
            |-
            ?~  flattened  acc
            ?.  (~(has by components.ui) ;;(@tas n.g.i.flattened))  $(flattened t.flattened)
            ?:  ?=(%root n.g.i.flattened)  $(flattened t.flattened)
            ?:  ?=(html-tag:html-tag n.g.i.flattened)  $(flattened t.flattened)
            =/  new-flattened
              =/  cid  (need (~(get-attr manx-tools i.flattened) g.i.flattened %sail-id))
              =/  ref  (~(get-attr manx-tools i.flattened) g.i.flattened %ref)
              ::::~&  "cid at click"
              ::::~&  cid
              =/  c  (~(get by components-state) cid)
              ?~  c  ~[i.flattened]
              =/  new-prop-vase
                =/  prop-tape
                  (~(get-attr manx-tools i.flattened) g.i.flattened %props)
                ?~  prop-tape  +.u.c
                !>((cue (slav %ud (crip u.prop-tape))))
              ::::~&  "c at click"
              ::::~&  c
              :: new-manx without root div (class .sail-component)
              =/  new-manx  +<:~(manx -.u.c new-prop-vase c.i.flattened [bowl cid ref])
              ::
              =/  inner=marl
                $(flattened ~(lvl-flatten-innertext manx-tools new-manx))
              ::::~&  "new-manx"
              ::::~&  new-manx
              ::::~&  "inner flattened"
              ::::~&  inner
            (weld ~(lvl-flatten-innertext manx-tools new-manx) inner)
              $(acc (weld new-flattened acc), flattened t.flattened)
            =/  find-cid
              %+  skim
                acc
              |=  =manx
              ^-  ?
              (~(has-attr-val manx-tools manx) g.manx %sail-id cid)
            ::::~&  "flattened acc"
            ::::~&  acc
            ::::~&  "find-cid"
            ::::~&  find-cid
            =/  ref
              ?~  find-cid  ~
            (~(get-attr manx-tools i.find-cid) g.i.find-cid %ref)
            =/  new-prop-vase
              ?~  find-cid
                +:u.c
              =/  prop-tape
                (~(get-attr manx-tools i.find-cid) g.i.find-cid %props)
              ?~  prop-tape  +.u.c
              !>((cue (slav %ud (crip u.prop-tape))))
            =/  previous-manx
              ?~  find-cid
                *manx
              ~(manx -.u.c +.u.c c.i.find-cid [bowl cid ref])
            =/  overwrite-manx
              |=  c=sail-component
              ^-  sail-component
              :: =/  tic  0
              :: wrap component in div with class .sail-component
              =/  new-c=sail-component
                |_  [=^vase children=marl bowl=sail-bowl]
                ++  on-init  ~(on-init c [vase children bowl])
                ++  on-poke  ~(on-poke c [vase children bowl])
                :: ++  manx  ~(manx -:u.^c [vase bowl])
                ++  manx
                  =/  target
                  ?:  =(cid "root")
                    (~(append-child manx-tools ;root;) ~(manx c [vase children bowl]))
                  ~(manx c [vase children bowl])
                  =/  source  ~(manx -:u.^c [vase children bowl])
                  =/  root-div  ;div.sail-component;
                  =/  target-w-root  (~(append-child manx-tools root-div) target)
                  ::::~&  "target-w-root"
                  ::::~&  target-w-root
                  ::::~&  "source"
                  ::::~&  source
                  :: (~(merge-all-attr manx-tools target-w-root) source)
                  (merge-manx:hc previous-manx target-w-root)
                --
              new-c
            :: ::::~&  c
            =;  [cards=(list card:agent:gall) component=sail-component]
            :: =/  state-update  (~(put by components-state) cid [(overwrite-manx component) new-prop-vase])

            =.  components-state  (~(put by components-state) cid [(overwrite-manx component) new-prop-vase])  :: overwrite manx arm
            :: ::~&  "new manx"
            :: ::~&  ~(manx (overwrite-manx component) new-prop-vase ~ [bowl cid ref])
            :: ::::~&  "+6 is"
            :: ::::~&  +6:(overwrite-manx component)
            =/  cards-out  (flop (weld cards ~[morph-fact]))
          :: ::::~&  morph-fact
            [cards-out this]
            :: (~(on-poke u.c ag-state [bowl cid]) [mark vase])
            :: ::::~&  new-prop-vase
            ?~  find-cid  `-:u.c
            (~(on-poke -:u.c [new-prop-vase c.i.find-cid [bowl cid ref]]) [mark vase])
          %keydown  ::TODO refactor this to a function
            =/  cid  (trip target:+>.poke)
            ::::~&  "cid at click"
            ::::~&  cid
            =/  c  (~(get by components-state) cid)
            ?~  c
            :: ::::~&  "no component found"
            `this
            =/  root-c  (~(got by components-state) "root")
            =/  root-manx  ~(manx -:root-c ag-state ~ [bowl "root" ~])
            ::TODO need to flatten only the subtree of the component that received the event
            ::TODO don't flatten children that are inner text
            =/  flattened  ~(lvl-flatten-innertext manx-tools root-manx)
            =/  acc  flattened
            ::  recurse through flattened tree and flatten nodes that resolve to sail-components, then weld to flattened
            =.  acc
            |-
            ?~  flattened  acc
            ?.  (~(has by components.ui) ;;(@tas n.g.i.flattened))  $(flattened t.flattened)
            ?:  ?=(%root n.g.i.flattened)  $(flattened t.flattened)
            ?:  ?=(html-tag:html-tag n.g.i.flattened)  $(flattened t.flattened)
            =/  new-flattened
              =/  cid  (need (~(get-attr manx-tools i.flattened) g.i.flattened %sail-id))
              =/  ref  (~(get-attr manx-tools i.flattened) g.i.flattened %ref)
              ::::~&  "cid at keydown"
              ::::~&  cid
              =/  c  (~(get by components-state) cid)
              ?~  c  ~[i.flattened]
              =/  new-prop-vase
                =/  prop-tape
                  (~(get-attr manx-tools i.flattened) g.i.flattened %props)
                ?~  prop-tape  +.u.c
                !>((cue (slav %ud (crip u.prop-tape))))
              ::::~&  "c at click"
              ::::~&  c
              :: new-manx without root div (class .sail-component)
              =/  new-manx  +<:~(manx -.u.c new-prop-vase c.i.flattened [bowl cid ref])
              ::
              =/  inner=marl
                $(flattened ~(lvl-flatten-innertext manx-tools new-manx))
              ::::~&  "new-manx"
              ::::~&  new-manx
            (weld ~(lvl-flatten-innertext manx-tools new-manx) inner)
              $(acc (weld new-flattened acc), flattened t.flattened)
            =/  find-cid
              %+  skim
                acc
              |=  =manx
              ^-  ?
              (~(has-attr-val manx-tools manx) g.manx %sail-id cid)
            ::::~&  "flattened acc"
            ::::~&  acc
            ::::~&  "find-cid"
            ::::~&  find-cid
            =/  ref
              ?~  find-cid  ~
            (~(get-attr manx-tools i.find-cid) g.i.find-cid %ref)
            =/  new-prop-vase
              ?~  find-cid
                +:u.c
              =/  prop-tape
                (~(get-attr manx-tools i.find-cid) g.i.find-cid %props)
              ?~  prop-tape  +.u.c
              !>((cue (slav %ud (crip u.prop-tape))))
            =/  previous-manx
              ?~  find-cid
                *manx
              ~(manx -.u.c +.u.c c.i.find-cid [bowl cid ref])
            ::~&  "previous-manx"
            ::~&  previous-manx
            =/  overwrite-manx
              |=  c=sail-component
              ^-  sail-component
              :: =/  tic  0
              :: wrap component in div with class .sail-component
              =/  new-c=sail-component
                |_  [=^vase children=marl bowl=sail-bowl]
                ++  on-init  ~(on-init c [vase children bowl])
                ++  on-poke  ~(on-poke c [vase children bowl])
                :: ++  manx  ~(manx -:u.^c [vase bowl])
                ++  manx
                  =/  target
                  ?:  =(cid "root")
                    (~(append-child manx-tools ;root;) ~(manx c [vase children bowl]))
                  ~(manx c [vase children bowl])
                  =/  source  ~(manx -:u.^c [vase children bowl])
                  =/  root-div  ;div.sail-component;
                  =/  target-w-root  (~(append-child manx-tools root-div) target)
                  ::::~&  "target-w-root"
                  ::::~&  target-w-root
                  ::::~&  "source"
                  ::::~&  source
                  (merge-manx:hc previous-manx target-w-root)
                --
              new-c
            :: ::::~&  c
            =;  [cards=(list card:agent:gall) component=sail-component]
            :: =/  state-update  (~(put by components-state) cid [(overwrite-manx component) new-prop-vase])

            =.  components-state  (~(put by components-state) cid [(overwrite-manx component) new-prop-vase])  :: overwrite manx arm
            :: ::~&  "new manx"
            :: ::~&  ~(manx (overwrite-manx component) new-prop-vase ~ [bowl cid ref])
            :: ::::~&  "+6 is"
            :: ::::~&  +6:(overwrite-manx component)
            =/  cards-out  (flop (weld cards ~[morph-fact]))
          :: ::::~&  morph-fact
            [cards-out this]
            :: (~(on-poke u.c ag-state [bowl cid]) [mark vase])
            :: ::::~&  new-prop-vase
            ?~  find-cid  `-:u.c
                            ~&  "key poke took"
    ~>  %bout
            (~(on-poke -:u.c [new-prop-vase c.i.find-cid [bowl cid ref]]) [mark vase])
              %mouseenter
            =/  cid  (trip target:+>.poke)
            :: ::::~&  "cid at click"
            :: ::::~&  cid
            =/  c  (~(get by components-state) cid)
            ?~  c
            ::::~&  "no component found"
            `this
            =/  root-c  (~(got by components-state) "root")
            =/  root-manx  ~(manx -:root-c ag-state ~ [bowl "root" ~])
            ::TODO need to flatten only the subtree of the component that received the event
            ::TODO don't flatten children that are inner text
            =/  flattened  ~(lvl-flatten-innertext manx-tools root-manx)
            =/  acc  flattened
            ::  recurse through flattened tree and flatten nodes that resolve to sail-components, then weld to flattened
            =.  acc
            |-
            ?~  flattened  acc
            ?.  (~(has by components.ui) ;;(@tas n.g.i.flattened))  $(flattened t.flattened)
            ?:  ?=(%root n.g.i.flattened)  $(flattened t.flattened)
            ?:  ?=(html-tag:html-tag n.g.i.flattened)  $(flattened t.flattened)
            =/  new-flattened
              =/  cid  (need (~(get-attr manx-tools i.flattened) g.i.flattened %sail-id))
              =/  ref  (~(get-attr manx-tools i.flattened) g.i.flattened %ref)
              ::::~&  "cid at click"
              ::::~&  cid
              =/  c  (~(get by components-state) cid)
              ?~  c  ~[i.flattened]
              =/  new-prop-vase
                =/  prop-tape
                  (~(get-attr manx-tools i.flattened) g.i.flattened %props)
                ?~  prop-tape  +.u.c
                !>((cue (slav %ud (crip u.prop-tape))))
              ::::~&  "c at click"
              ::::~&  c
              :: new-manx without root div (class .sail-component)
              =/  new-manx  +<:~(manx -.u.c new-prop-vase c.i.flattened [bowl cid ref])
              ::
              =/  inner=marl
                $(flattened ~(lvl-flatten-innertext manx-tools new-manx))
              ::::~&  "new-manx"
              ::::~&  new-manx
            (weld ~(lvl-flatten-innertext manx-tools new-manx) inner)
              $(acc (weld new-flattened acc), flattened t.flattened)
            =/  find-cid
              %+  skim
                acc
              |=  =manx
              ^-  ?
              (~(has-attr-val manx-tools manx) g.manx %sail-id cid)
            ::::~&  "flattened acc"
            ::::~&  acc
            ::::~&  "find-cid"
            ::::~&  find-cid
            =/  ref
              ?~  find-cid  ~
            (~(get-attr manx-tools i.find-cid) g.i.find-cid %ref)
            =/  new-prop-vase
              ?~  find-cid
                +:u.c
              =/  prop-tape
                (~(get-attr manx-tools i.find-cid) g.i.find-cid %props)
              ?~  prop-tape  +.u.c
              !>((cue (slav %ud (crip u.prop-tape))))
            =/  previous-manx
              ?~  find-cid
                *manx
              ~(manx -.u.c +.u.c c.i.find-cid [bowl cid ref])
                          ::~&  "previous-manx"
            ::~&  previous-manx
            =/  overwrite-manx
              |=  c=sail-component
              ^-  sail-component
              :: =/  tic  0
              :: wrap component in div with class .sail-component
              =/  new-c=sail-component
                |_  [=^vase children=marl bowl=sail-bowl]
                ++  on-init  ~(on-init c [vase children bowl])
                ++  on-poke  ~(on-poke c [vase children bowl])
                :: ++  manx  ~(manx -:u.^c [vase bowl])
                ++  manx
                  =/  target
                  ?:  =(cid "root")
                    (~(append-child manx-tools ;root;) ~(manx c [vase children bowl]))
                  ~(manx c [vase children bowl])
                  =/  source  ~(manx -:u.^c [vase children bowl])
                  =/  root-div  ;div.sail-component;
                  =/  target-w-root  (~(append-child manx-tools root-div) target)
                  ::::~&  "target-w-root"
                  ::::~&  target-w-root
                  ::::~&  "source"
                  ::::~&  source
                  :: (~(merge-all-attr manx-tools target-w-root) source)
                  (merge-manx:hc previous-manx target-w-root)
                --
              new-c
            :: ::::~&  c
            =;  [cards=(list card:agent:gall) component=sail-component]
            :: =/  state-update  (~(put by components-state) cid [(overwrite-manx component) new-prop-vase])

            =.  components-state  (~(put by components-state) cid [(overwrite-manx component) new-prop-vase])  :: overwrite manx arm
            ::::~&  "new manx"
            ::::~&  ~(manx (overwrite-manx component) new-prop-vase ~ [bowl cid ref])
            :: ::::~&  "+6 is"
            :: ::::~&  +6:(overwrite-manx component)
            =/  cards-out  (flop (weld cards ~[morph-fact]))
          :: ::::~&  morph-fact
            [cards-out this]
            :: (~(on-poke u.c ag-state [bowl cid]) [mark vase])
            :: ::::~&  new-prop-vase
            ?~  find-cid  `-:u.c
            (~(on-poke -:u.c [new-prop-vase c.i.find-cid [bowl cid ref]]) [mark vase])
                %mouseleave
            =/  cid  (trip target:+>.poke)
            :: ::::~&  "cid at click"
            :: ::::~&  cid
            =/  c  (~(get by components-state) cid)
            ?~  c
            ::::~&  "no component found"
            `this
            =/  root-c  (~(got by components-state) "root")
            =/  root-manx  ~(manx -:root-c ag-state ~ [bowl "root" ~])
            ::TODO need to flatten only the subtree of the component that received the event
            ::TODO don't flatten children that are inner text
            =/  flattened  ~(lvl-flatten-innertext manx-tools root-manx)
            =/  acc  flattened
            ::  recurse through flattened tree and flatten nodes that resolve to sail-components, then weld to flattened
            =.  acc
            |-
            ?~  flattened  acc
            ?.  (~(has by components.ui) ;;(@tas n.g.i.flattened))  $(flattened t.flattened)
            ?:  ?=(%root n.g.i.flattened)  $(flattened t.flattened)
            ?:  ?=(html-tag:html-tag n.g.i.flattened)  $(flattened t.flattened)
            =/  new-flattened
              =/  cid  (need (~(get-attr manx-tools i.flattened) g.i.flattened %sail-id))
              =/  ref  (~(get-attr manx-tools i.flattened) g.i.flattened %ref)
              ::::~&  "cid at click"
              ::::~&  cid
              =/  c  (~(get by components-state) cid)
              ?~  c  ~[i.flattened]
              =/  new-prop-vase
                =/  prop-tape
                  (~(get-attr manx-tools i.flattened) g.i.flattened %props)
                ?~  prop-tape  +.u.c
                !>((cue (slav %ud (crip u.prop-tape))))
              ::::~&  "c at click"
              ::::~&  c
              :: new-manx without root div (class .sail-component)
              =/  new-manx  +<:~(manx -.u.c new-prop-vase c.i.flattened [bowl cid ref])
              ::
              =/  inner=marl
                $(flattened ~(lvl-flatten-innertext manx-tools new-manx))
              ::::~&  "new-manx"
              ::::~&  new-manx
            (weld ~(lvl-flatten-innertext manx-tools new-manx) inner)
              $(acc (weld new-flattened acc), flattened t.flattened)
            =/  find-cid
              %+  skim
                acc
              |=  =manx
              ^-  ?
              (~(has-attr-val manx-tools manx) g.manx %sail-id cid)
            ::::~&  "flattened acc"
            ::::~&  acc
            ::::~&  "find-cid"
            ::::~&  find-cid
            =/  ref
              ?~  find-cid  ~
            (~(get-attr manx-tools i.find-cid) g.i.find-cid %ref)
            =/  new-prop-vase
              ?~  find-cid
                +:u.c
              =/  prop-tape
                (~(get-attr manx-tools i.find-cid) g.i.find-cid %props)
              ?~  prop-tape  +.u.c
              !>((cue (slav %ud (crip u.prop-tape))))
            =/  previous-manx
              ?~  find-cid
                *manx
              ~(manx -.u.c +.u.c c.i.find-cid [bowl cid ref])
                          ::~&  "previous-manx"
            ::~&  previous-manx
            =/  overwrite-manx
              |=  c=sail-component
              ^-  sail-component
              :: wrap component in div with class .sail-component
              =/  new-c=sail-component
                |_  [=^vase children=marl bowl=sail-bowl]
                ++  on-init  ~(on-init c [vase children bowl])
                ++  on-poke  ~(on-poke c [vase children bowl])
                :: ++  manx  ~(manx -:u.^c [vase bowl])
                ++  manx
                  =/  target
                  ?:  =(cid "root")
                    (~(append-child manx-tools ;root;) ~(manx c [vase children bowl]))
                  ~(manx c [vase children bowl])
                  =/  source  ~(manx -:u.^c [vase children bowl])
                  =/  root-div  ;div.sail-component;
                  =/  target-w-root  (~(append-child manx-tools root-div) target)
                  (merge-manx:hc previous-manx target-w-root)
                --
              new-c
            :: ::::~&  c
            =;  [cards=(list card:agent:gall) component=sail-component]
            :: =/  state-update  (~(put by components-state) cid [(overwrite-manx component) new-prop-vase])

            =.  components-state  (~(put by components-state) cid [(overwrite-manx component) new-prop-vase])  :: overwrite manx arm
            ::::~&  "new manx"
            ::::~&  ~(manx (overwrite-manx component) new-prop-vase ~ [bowl cid ref])
            :: ::::~&  "+6 is"
            :: ::::~&  +6:(overwrite-manx component)
            =/  cards-out  (flop (weld cards ~[morph-fact]))
          :: ::::~&  morph-fact
            [cards-out this]
            :: (~(on-poke u.c ag-state [bowl cid]) [mark vase])
            :: ::::~&  new-prop-vase
            ?~  find-cid  `-:u.c
            (~(on-poke -:u.c [new-prop-vase c.i.find-cid [bowl cid ref]]) [mark vase])
            == 
    ==
    ==
    ::
  ++  on-peek
    |=  =path
    ^-  (unit (unit cage))
      (on-peek:ag path)
  ::
  ::TODO  generate id for manx elements and add to components-state
  ::TODO  enchance bowl to include component id
  ++  on-init
    ^-  (quip card:agent:gall agent:gall)
    ::
    :: ::::~&  >  'on-init at ui2'
    =^  cards  agent  on-init:ag
    =/  sail-root  (wrap-ui-root:hc root.ui)
    =.  components.ui
      (~(put by components.ui) %root sail-root)
    =/  root-manx
      ~(manx sail-root [ag-state ~ [bowl "root" ~]])
    =/  init-state
      (image-to-instance:hc root-manx &)
    :: extract event listeners from on-init cards
    =/  event-listeners-cards=(list card:agent:gall)
      %+  skim
        `(list card:agent:gall)`-<.init-state
      |=  =card:agent:gall
      ^-  ?
      ?=([%give [%fact [* [%domevents *]]]] card)

    =/  event-listeners=(list [@t (list term)])
      %+  turn
        event-listeners-cards
      |=  =card:agent:gall
      ^-  [@t (list term)]
      ?>  ?=(%give -.card)
      ?>  ?=(%fact +<.card)
      =+  !<(listeners=[@t (list term)] +>+>.card)
      listeners
    ::
    =.  root-manx
      ~(manx (~(got by ->.init-state) "root") [ag-state ~ [bowl "root" ~]])
    =/  manx
      abet:(transform-manx [root-manx ->.init-state ag-state bowl])
      :: ~&  "nid-map"
      :: ~&  +.init-state
    :: ::::~&  "init-state cards"
    :: ::::~&  -.init-state
    :: ::::~&  "event-listeners"
    :: ::::~&  event-listeners
    :: ::::~&  `manx`test
    :: ::::~&  (image-to-instance sail-w-id)
    :: ::::~&  (apply-elem sail generate-id 0)
    [(weld cards -<.init-state) this(current-manx manx, components-state ->.init-state, dom-event-listeners event-listeners, nid-map +.init-state)]   ::TODO process incoming components to extract ids for nid-map ::TODO refactor sail inp
    
    :: [cards this(components-state components, nid-map (~(put by nid-map) 'i1' [~.random-number (reduce-sample:(transform-manx [(sail components) components ag-state bowl]) (sail components))]))]   ::TODO process incoming components to extract ids for nid-map ::TODO refactor sail inp
  ::
  ++  on-save  !>([[%ui-wrapper wrapper-state] on-save:ag])
  ::
  ++  on-load
    |=  ole=vase
    :: ::::~&  sail
    ^-  (quip card:agent:gall agent:gall)
    ?.  ?=([[%ui-wrapper *] *] q.ole)
    =^  cards   agent   (on-load:ag ole)
      [cards this]
    =+  !<([[%ui-wrapper old=^wrapper-state] ile=vase] ole)
    :: ::::~&  q.ile
    =^  cards  agent  (on-load:ag ile)
    [cards this(wrapper-state old)]
  ::
  ::
  ++  on-watch
    |=  =path
    ^-  (quip card:agent:gall agent:gall)
    ?+  path  (on-watch:ag path)
      [%http-response *]  [~ this]
      ::
      [%morph ~]
    :_  this
    ~
    ::
      [%event-listeners ~]
    :_  this
    :: for each component in components-state, send event-listeners
    
    :~
    (fact-init:io [%json !>((all-domevents-json dom-event-listeners))])
    ==
    ==
  ::
  ::
  ++  on-leave
    |=  =path
    ^-  (quip card:agent:gall agent:gall)
    =^  cards  agent  (on-leave:ag path)
    [cards this]
  ::
  ++  on-agent
    |=  [=wire =sign:agent:gall]
    ^-  (quip card:agent:gall agent:gall)
    =^  cards  agent  (on-agent:ag wire sign)
    [cards this]
  ::
  ++  on-arvo
    |=  [=wire =sign-arvo]
    ^-  (quip card:agent:gall agent:gall)
    =^  cards  agent  (on-arvo:ag wire sign-arvo)
    [cards this]
  ::
  ++  on-fail
    |=  [=term =tang]
    ^-  (quip card:agent:gall agent:gall)
    =^  cards  agent  (on-fail:ag term tang)
    [cards this]
  --
++  hc
|_  [ui=[=components root=sail-component] =agent:gall =bowl:gall]
+*    ag    ~(. agent bowl)
      ag-state    on-save:ag
++  wrap-ui-root
  |=  c=sail-component
  ^-  sail-component
  :: =/  tic  0
  :: wrap component in div with class .sail-component
  =/  new-c=sail-component
    |_  [=vase children=marl bowl=sail-bowl]
    ++  on-init  ~(on-init c [vase children bowl])
    ++  on-poke  ~(on-poke c [vase children bowl])
    ++  manx
      :: ~&  "wrap-ui-root"
      =/  man  ~(manx c [vase children bowl])
      :: =/  root-div  ;root;
        (~(append-child manx-tools ;root;) man)
    --
  new-c
::
++  give-ids  ::TODO rename
  |=  [c=sail-component cid=tape]
  ^-  sail-component
  :: =/  tic  0
  :: wrap component in div with class .sail-component
  :: and give ids to all elements in the component
  =/  new-c=sail-component
    |_  [=vase children=marl bowl=sail-bowl]
    +*  this  .
    ++  on-init  ~(on-init c [vase children bowl])
    ++  on-poke
      :: =/  new
      ::   |_  [v=_vase b=_bowl]
      ::   ++  on-poke  ~(on-poke c [v b])
      ::   ++  manx  manx
      ::   --
      :: ::::~&  "on-poke new-c"
      :: ::::~&  manx:+:~(on-poke c [vase bowl])
      :: ^-  (quip card:agent:gall sail-component)
      ~(on-poke c [vase children bowl])
      :: [-.- +.-]
    ++  manx
      =/  man  ~(manx c vase children bowl)
        =/  cid-ud
          ?:  =("root" cid)  1  (slav %ud (crip cid))
        =/  with-ids  (apply-elem man cid-ud 1 generate-id)
        =/  root-div  ;div.sail-component(sail-id cid);
        ?:  =(g:`^manx`with-ids g:`^manx`root-div)
        :: ::~&  "not appending root-div"
        with-ids
      (~(append-child manx-tools root-div) with-ids)
    --
  :: ::::~&  "new-c manx"
  :: ::::~&  manx:new-c
  new-c

++  image-to-instance
:: loop over sail to generate instance of components
::TODO collect props from sail
:: props are in sail props attribute as jammed noun encoded as tape
  |=  [=manx init=?]
    ::~&  manx

  ^-  [(quip card:agent:gall component-instances) (map @ta @ud)]
    ::~&  "image-to-instance"
    =/  tic  0
    =|  cards=(list card:agent:gall)
                    ~&  "iti recursion took"
    ~>  %bout
    |-
    :: ::~&  manx
    :: =^  with-ids  tic  (apply-elem manx generate-id tic)
    :: ::::~&  with-ids
    ::
    :: =/  flattened=marl
    ::   ?:  init  ~(lvl-flatten-innertext manx-tools manx)
      =/  flattened  ~(lvl-flatten-innertext manx-tools manx)
    :: :: ?:  (~(has by components-state) (need cid))  $(flattened t.flattened)  ::TODO cannot do this because component manx may have changed since it was instantiated
    :: ::  recurse through flattened tree and flatten nodes that resolve to sail-components, then weld to flattened

    :: =/  acc  flattened
    :: =.  acc
    :: |-
    :: ?~  flattened  acc
    :: ::::~&  "flattened at recurse"
    :: ::::~&  flattened
    :: ?.  (~(has by components.ui) ;;(@tas n.g.i.flattened))  $(flattened t.flattened)
    :: ?:  ?=(%root n.g.i.flattened)  $(flattened t.flattened)
    :: ?:  ?=(html-tag:html-tag n.g.i.flattened)  $(flattened t.flattened)
    :: =/  new-flattened
    :: ::::~&  "new-flattened"
    ::   =/  cid  (need (~(get-attr manx-tools i.flattened) g.i.flattened %sail-id))
    ::   ::::~&  "cid at recurse"
    ::   ::::~&  cid
    ::   :: ?:  (~(has by components-state) (need cid))  $(flattened t.flattened)
    ::   =/  ref  (~(get-attr manx-tools i.flattened) g.i.flattened %ref)
    ::   :: ::::~&  "cid at click"
    ::   :: ::::~&  cid
    ::   =/  props=(unit tape)
    ::   (~(get-attr manx-tools *^manx) g.i.flattened %props)
    ::   =/  cued-props-vase
    ::   :: ::::~&  "cued-props-vase called"
    ::   :: ?:  ?=(%root ;;(@tas n.g.i.flattened))  ag-state
    ::   ?~  props  !>(~)
    ::   !>
    ::   (cue (slav %ud (crip u.props)))
    ::   =/  c  (~(get by components-state) cid)
    ::   ?~  c  
    ::   ::::~&  "c is null"
    ::   ~[i.flattened]
    ::     :: ~(lvl-flatten-innertext manx-tools new-manx)
    ::   =/  new-manx  ~(manx -.u.c cued-props-vase c.i.flattened [bowl cid ref])
    ::   =/  inner=marl
    ::     $(flattened ~(lvl-flatten-innertext manx-tools new-manx))
    ::     ::::~&  "new-manx"
    ::     ::::~&  new-manx
    ::   (weld ~(lvl-flatten-innertext manx-tools new-manx) inner)
    ::   $(acc (weld new-flattened acc), flattened t.flattened)
    ::   acc
    ::
    |-
    :: ::~&  "flattened"
    :: ::~&  flattened
    ?~  flattened  
    :: ::::~&  components-state
    :: ::~&  "flattened is null and cards is"
    :: ::~&  cards
    :: :_  tic
  ::         ~&  "nid-map is"
  :: ~&  nid-map
    [[cards components-state] nid-map]
    :: ::::~&  n.g.i.flattened
    :: ::::~&  (~(has by components.ui) ;;(@tas n.g.i.flattened))
    ?.  (~(has by components.ui) ;;(@tas n.g.i.flattened)) ::TODO ;; @tas n.g
      $(flattened t.flattened)
    ?:  ?=(html-tag:html-tag n.g.i.flattened)  $(flattened t.flattened)
    =/  cid=(unit tape)
      ?:  ?=(%root ;;(@tas n.g.i.flattened))  `"root"
      (~(get-attr manx-tools *^manx) g.i.flattened %sail-id)
    =/  nid-tic
      =+  (~(get by nid-map) ;;(@ta n.g.i.flattened))
      ?~  -  0
      u.-
    :: ?:  (~(has by components-state) (need cid))
      ::::~&  "has by components-state, skipping"
      :: $(flattened t.flattened)  ::TODO cannot do this because component manx may have changed since it was instantiated
    ::
    :: ::::~&  n.g.i.flattened
    
    =/  c
      ?~  cid  (~(got by components.ui) ;;(@tas n.g.i.flattened))
      ?:  (~(has by components-state) (need cid))
        :: ::~&  "has by components-state, using that"
        -:(~(got by components-state) (need cid))
    (~(got by components.ui) ;;(@tas n.g.i.flattened))
    :: ::::~&  c
    =/  props=(unit tape)
      (~(get-attr manx-tools *^manx) g.i.flattened %props)
    =/  children  c.i.flattened
    =/  prev-props-vase=(unit vase)
      ?~  cid  ~
      =/  prev-c  (~(get by components-state) (need cid))
      ?~  prev-c  ~
      `+.u.prev-c
    =/  cued-props-vase
      :: ::::~&  "cued-props-vase called"
      ?:  ?=(%root ;;(@tas n.g.i.flattened))  ag-state
      ?~  props  !>(~)
      !>
      (cue (slav %ud (crip u.props)))
    =/  ref
      (~(get-attr manx-tools *^manx) g.i.flattened %ref)



  ::       ::~&  "prev manx from c"
  ::       :: ::~&  "cid"
  ::       :: ::~&  cid
  ::       ::~&  ?.  ?=(%todocontainer ;;(@tas n.g.i.flattened))  "not todocontainer"
  ::         :: ?.(=(~ prev-props-vase) ~(manx c (need prev-props-vase) children [bowl (need cid) ref]) ~)
  ::       ::~&  "new manx from c"
  ::       ::~&  ?.  ?=(%todocontainer ;;(@tas n.g.i.flattened))  "not todocontainer"
  ::         :: ?.(=(~ prev-props-vase) ~(manx c cued-props-vase children [bowl (need cid) ref]) ~)
  ::       ::~&  "current i.flattened"
  ::       ::~&  i.flattened
  ::       ::~&  "merged manx from c"
  ::       ::~&  ?.(=(~ prev-props-vase) (merge-manx ~(manx c (need prev-props-vase) children [bowl (need cid) ref]) ~(manx c cued-props-vase children [bowl (need cid) ref])) ~)

        ::TODO  delete instance of component if it is not in the dom anymore
        ::  we can do this by comparing the current manx with the previous manx
        =/  remove-instances
          ?~  cid  ~
          ?~  prev-props-vase  ~
          =/  prev-manx
            ~(manx c (need prev-props-vase) children [bowl (need cid) ref])
          =/  new-manx
            ~(manx c cued-props-vase children [bowl (need cid) ref])
          =/  merged
            (merge-manx prev-manx new-manx)
          =/  not-in-new-manx
            %~  tap  in
            %-  %~  dif  in
                  ::TODO  need to flatten the manx with elements' attributes other than sail-id and ref removed
                  (silt ~(lvl-flatten-innertext-sail-id manx-tools prev-manx))
            (silt ~(lvl-flatten-innertext-sail-id manx-tools merged))
            ::~&  "set of prev-manx"
            ::~&  (silt ~(lvl-flatten-innertext-sail-id manx-tools prev-manx))
            ::~&  "set of new-manx"
            ::~&  (silt ~(lvl-flatten-innertext-sail-id manx-tools merged))
            ::  skip html elements
          %+  skip  not-in-new-manx
          |=  =^manx
          ?=(?(%$ html-tag:html-tag) n.g.manx)
  ::       ::~&  "remove-instances"
  ::       ::~&  remove-instances

  ::         ~&  "nid-map before c-w-ids is"
  :: ~&  nid-map
    =/  c-w-ids
                        ~&  "give-ids took"
    ~>  %bout
    (give-ids c (need cid))
    :: =/  c-w-ids-init  (give-ids-init c (need cid) +(tic))

  ::       :: ~&  ?.  ?=(%todo ;;(@tas n.g.i.flattened))  "not todo"
      
  ::   =/  c-w-ids  (give-ids c (need cid) +(tic))
  ::   :: ::~&  "manx at c-w-ids"
  ::   :: ::~&  ~(manx c-w-ids cued-props-vase children [bowl (need cid) ref])
  ::   :: ::::~&  +<+<:~(manx c-w-ids ag-state [bowl (need cid)])
  ::   :: ::::~&  'after c-w-ids'
    =/  c-i
      :: =/  man
        :: ::::~&  "c-i manx"
      ::   ;;(^manx ~(manx c-w-ids cued-props-vase [bowl (need cid)]))
        :: ::::~&  man
        :: ::::~&  cued-props-vase
      |_  [=vase children=marl bowl=sail-bowl]
        ++  on-init  ~(on-init c-w-ids [vase children bowl])
        ++  on-poke  ~(on-poke c-w-ids [vase children bowl])
        ++  manx  ~(manx c-w-ids [vase children bowl])
      --
    =/  c-cards=(list card:agent:gall)
      ?:  (~(has by components-state) (need cid))  ~
      =/  c-cards  -:~(on-init c [cued-props-vase children [bowl (need cid) ref]])
      :: =/  c-cards  -:~(on-init c-i [cued-props-vase children [bowl (need cid) ref]])
      ?~  (find c-cards cards)  c-cards
        ~
  ::   :: ?:  (~(has by components-state) (need cid))
  ::   :: ::~&  "has by components-state, skipping"
    =/  updated-c
      |_  [=vase children=marl bowl=sail-bowl]
        ++  on-init  ~(on-init c [vase children bowl])
        ++  on-poke  ~(on-poke c [vase children bowl])
        ++  manx
                                ~&  "merge-manx took"
    ~>  %bout
          (merge-manx ~(manx c (need prev-props-vase) ^children [^bowl (need cid) ref]) ~(manx c vase ^children [^bowl (need cid) ref]))
        --
  ::   =?  nid-map  !(~(has by components-state) (need cid))
  ::     ~&  "{<;;(@tas n.g.i.flattened)>} {(need cid)} put to nid-map"
  ::     (~(put by nid-map) ;;(@ta n.g.i.flattened) +(nid-tic))
    =.  components-state
      ?.  (~(has by components-state) (need cid))
        :: ~&  "{<;;(@tas n.g.i.flattened)>} {(need cid)} put to instances"
        (~(put by components-state) [(need cid) [c-i cued-props-vase]])
        :: (~(put by components-state) [(need cid) [c cued-props-vase]])

      :: ~&  "{<;;(@tas n.g.i.flattened)>} {(need cid)} instance updated"
      (~(put by components-state) [(need cid) [updated-c cued-props-vase]])
        =+
        |-
        ?~  remove-instances
          components-state
        %=  $
          remove-instances  t.remove-instances
          components-state
          :: ~&  "{<;;(@tas n.g.i.remove-instances)>} {(need (~(get-attr manx-tools *^manx) g.i.remove-instances %sail-id))} instance removed"
          (~(del by components-state) (need (~(get-attr manx-tools *^manx) g.i.remove-instances %sail-id)))
        ==
      =.  components-state  -
      
    :: ::::~&  cid

    :: cards from component's on-init
    :: if not an html element, get component manx and recurse
    ?:  ?=(%root n.g.i.flattened)
    :: ::~&  "root, recurse into"
    :: $(flattened t.flattened)
      :: =/  inner-components-state=component-instances
        :: ^$(manx `^manx`+<+<+<:~(manx c ag-state children [bowl (need cid) ref]), tic +(tic), cards (weld cards c-cards))
        ^$(manx `^manx`+<+<+<:~(manx c-i ag-state children [bowl (need cid) ref]), tic +(tic), cards (weld cards c-cards))
    :: $(flattened t.flattened, components-state (~(uni by components-state) inner-components-state))

      :: $(flattened t.flattened)
    =/  inner-components-state=[(quip card:agent:gall component-instances) (map @ta @ud)]
      :: ::~&  "recurse into innner components"
      =/  c-i
        ?:  !=(~ prev-props-vase)
          updated-c
        c-i
        :: c
      ^$(manx ~(manx c-i [cued-props-vase children [bowl (need cid) ref]]), tic +(tic), cards ~)
      :: ^$(manx ~(manx c [cued-props-vase children [bowl (need cid) ref]]), tic +(tic), cards ~)

    :: ::::~&  inner-components-state
      :: ~&  "uni nid-map after {<;;(@tas n.g.i.flattened)>} {(need cid)} instance is"
  :: ~&  (~(uni by nid-map) +.inner-components-state)
    $(flattened t.flattened, nid-map (~(uni by nid-map) +.inner-components-state), components-state (~(uni by components-state) ->.inner-components-state), cards :(weld cards c-cards -<.inner-components-state))

::
  ++  merge-manx
    |=  [s=manx t=manx]
    |^
    ^-  manx
    :: ::~&  "s"
    :: ::~&  s
    :: ::~&  "t"
    :: ::~&  t
    :: ::~&  "=(n.g.s n.g.t)"
    :: ::~&  =(n.g.s n.g.t)
    ?.  =(n.g.s n.g.t)
      :: ^$(acc (snoc c.acc t), t i.c.t)
      [g.t (cloop c.s c.t)]
    [g:(merge-attr s t %sail-id) (cloop c.s c.t)]
    ++  cloop
    |=  [cs=marl ct=marl]
    ?~  ct  ~
    ?~  cs  [^$(t i.ct) (cloop ~ t.ct)]
    ?.  =(n.g.i.cs n.g.i.ct)
      [^$(s i.cs, t i.ct) (cloop cs t.ct)]
    [^$(s i.cs, t i.ct) (cloop t.cs t.ct)]
  ++  merge-attr
    |=  [a=manx man=manx =mane]
    :: ::~&  "a manx"
    :: ::~&  a
    :: ::~&  "man manx"
    :: ::~&  man
    |^  ^-  manx
    :: =/  attrs  a.g.a
    :: =/  attrs-mane  (turn attrs |=([=^mane tape] mane))
    :: =/  man-attrs  (wo-text a.g.man)
    :: =/  merged
    ::   =/  source-sid-index  (find [mane]~ man-attrs)
    ::   ?~  source-sid-index  attrs
    ::   =/  source-sid  (snag u.source-sid-index man-attrs)
    ::   ?~  (find [mane]~ attrs-mane)
    ::     =.  attrs  (snoc attrs source-sid)
    ::     attrs
    ::   attrs
    :: [g.a(a (weld merged (skip man-attrs |=(attr=(pair ^mane tape) =(mane p.attr))))) (cloop c.a c.man)]

    =/  attrs  a.g.a
    :: ::~&  "attrs"
    :: ::~&  attrs
    :: ::~&  "man attrs"
    :: ::~&  a.g.man
    :: skip those attributes that aren't in .man, leave .sail-id intact
    =.  attrs
      %+  skip
        attrs
      |=  attr=(pair ^mane tape)
      ?&  !(~(has by (molt a.g.man)) p.attr)
          !=(mane p.attr)
      ==
    =/  merged
      =/  man-attrs  a.g.man
      |-
    =/  attrs-mane  (turn attrs |=([=^mane tape] mane))
      =/  man-attrs-mane  (turn man-attrs |=([=^mane tape] mane))
      ?~  man-attrs  attrs
      ?~  man-attrs-mane  attrs
      :: ::~&  "i.man-attrs"
      :: ::~&  i.man-attrs
      :: ::~&  "i.man-attrs-mane"
      :: ::~&  i.man-attrs-mane
      ?:  =(mane i.man-attrs-mane)  $(man-attrs t.man-attrs)
      =/  index  (find [i.man-attrs-mane]~ attrs-mane)
      :: ::~&  "index"
      :: ::~&  index
      ?~  index  $(attrs (snoc attrs i.man-attrs), man-attrs t.man-attrs) ::TODO|DONE snoc only if not already in attrs, ignore if already in attrs regardless of value
      =/  replaced
        =.  attrs
          %^  snap
            attrs
            u.index
          i.man-attrs
        attrs
        :: ::~&  "replaced"
        :: ::~&  replaced
      $(attrs replaced, man-attrs t.man-attrs)
    [g.a(a merged) (cloop c.a c.man)]
      ++  cloop
        |=  [c=marl cman=marl]
        ?~  c  ~
        ?~  cman  ~
        [^$(a i.c, man i.cman) (cloop t.c t.cman)]
      ++  wo-text
        |=  attrs=mart
        %+  skip
          attrs
        |=  attr=(pair ^mane tape)
        ?=(%$ p.attr)
      --
    --
++  apply-elem
  |=  [a=manx parent=@ self=@ b=$-([marx [@ @]] marx)]
  |^  ^-  manx
  :: ~&  "{<;;(@tas n.g.a)>} parent is {<parent>} and self is {<self>}"
  [(b g.a [parent self]) (cloop(parent :(add (mug n.g.a) (mug parent) (mug self)), self 0) c.a)]
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
  =/  id
    :(add (mug n.marx) (mug p) (mug s))
    :: :(mul (mug n.marx) p s)
  =.  a.marx
  (snoc a.marx [%sail-id <id>])
  marx
--
--