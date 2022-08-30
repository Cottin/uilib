import always from "ramda/es/always"; import equals from "ramda/es/equals"; import flip from "ramda/es/flip"; import type from "ramda/es/type"; #auto_require: esramda
import {change} from "ramda-extras" #auto_require: esramda-extras

import React from 'react'


export memoDeep = (f) -> React.memo f, equals

export isMountedGuard = (isMountedRef) ->
  # https://daviseford.com/blog/2019/07/11/react-hooks-check-if-mounted.html
  React.useEffect (() -> () -> return isMountedRef.current = false), []

export useChangeState = (initial) ->
  [state, setState] = React.useState initial
  changeState = (spec) -> setState change spec
  resetState = -> setState initial
  return [state, changeState, resetState]

# Assumes ref is absolutely positioned relative to a parent and returns the nessecary adjustments needed
# to contain the ref within the viewport in shortstyle format.
# eg. if the ref is outside the viewport to the right, returned might be rig-54
# NOTE: only supporting left and right for now, add top and bottom when needed
export useContainRelativeToParent = (ref) ->
  [s, cs] = useChangeState {left: null, right: null}

  handleResize = ->
    viewportOffset = elementViewportOffset ref.current
    parentViewportOffset = elementViewportOffset ref.current?.offsetParent
    if viewportOffset.right < 0
      cs {left: 'auto', right: -1 * parentViewportOffset.right}
    if viewportOffset.left < 0
      cs {right: 'auto', left: -1 * parentViewportOffset.left}

  React.useEffect ->
    handleResize()
    window.addEventListener 'resize', handleResize
    return () -> window.removeEventListener 'resize', handleResize
  , [ref.current]

  return toShortstyleTest s

# convenient if you want to write short one-line useEffects and more beautiful than flip(React.useEffect) ..
export useEffectFlipped = flip React.useEffect

export useFocus = (deps) ->
  # NOTE!!!!!!! Doesn't really seem to work. Else part is needed but it throws error when component is removed
  #             Use autoFocus: true instead and go back to this when that is not enough anymore
  ref = React.useRef()
  React.useEffect ->
    if ref?.current then ref.current?.focus()
    # else
    #   flip(setTimeout) 10, ->
    #     ref?.current?.focus() # give time if conditonal render
  , deps
  return ref

export useForceScrollbar = () ->
  React.useEffect ->
    document.body.style.overflowY = 'scroll'
    return () -> document.body.style.overflowY = 'initial'
  , []
  return null

export useOuterClick = (ref, onOuterClick) ->
  React.useEffect ->
    handleClick = (e) -> if ref.current && !ref.current.contains(e.target) then onOuterClick()
    # {capture: true} important if we are also removing the element that's being clicked eg. a toggle.
    # https://github.com/facebook/react/issues/20325#issuecomment-732707240
    if ref.current then document.addEventListener 'click', handleClick, {capture: true}
    return () -> document.removeEventListener 'click', handleClick, {capture: true}
  , [ref, onOuterClick]

export useOuterMouseDown = (ref, onOuterMouseDown) ->
  React.useEffect ->
    handleClick = (e) -> if ref.current && !ref.current.contains(e.target) then onOuterMouseDown(e)
    # {capture: true} important if we are also removing the element that's being clicked eg. a toggle.
    # https://github.com/facebook/react/issues/20325#issuecomment-732707240
    if ref.current then document.addEventListener 'mousedown', handleClick, {capture: true}
    return () -> document.removeEventListener 'mousedown', handleClick, {capture: true}
  , [ref, onOuterMouseDown]

# Returns size of supplied ref like {width: 344, height: 102} and updates on window resize
export useMySize = (ref) ->
  [size, setSize] = React.useState {width: 0, height: 0}

  handleResize = ->
    width = ref.current?.offsetWidth || 0
    height = ref.current?.offsetHeight || 0
    setSize {width, height}

  React.useEffect ->
    handleResize()
    window.addEventListener 'resize', handleResize
    return () -> window.removeEventListener 'resize', handleResize
  , [ref.current]

  return size

# Returns size of window like {width: 344, height: 102} and updates on window resize
export useWindowSize = () ->
  [size, setSize] = React.useState {width: 0, height: 0}

  handleResize = ->
    width = window.innerWidth
    height = window.innerWidth
    setSize {width, height}

  React.useEffect ->
    handleResize()
    window.addEventListener 'resize', handleResize
    return () -> window.removeEventListener 'resize', handleResize
  , []

  return size

# https://stackoverflow.com/a/53180013
export useDidUpdateEffect = (fn, deps) ->
  ref = React.useRef false

  React.useEffect () ->
    if ref.current then fn() else ref.current = true
    return () -> #noop
  , deps


_useCall = ({successDelay = 1500, onError = null, asyncCall}) ->
  isMounted = React.useRef true
  isMountedGuard isMounted

  [st, cs] = useChangeState {}

  callFn = (args...) ->
    cs {wait: true, error: undefined, result: undefined}
    try
      result = await Promise.resolve asyncCall args...
      if result == 'ABORT'
        cs {wait: false}
        return result
      if !isMounted.current then return result

      cs {wait: false, success: true, result}
      if successDelay > 0 then setTimeout (->
        if !isMounted.current then return result
        cs {success: undefined}), successDelay

      return result
    catch error
      onError?(error)
      cs always {error, wait: false}
      console.error error

  return 
    wait: st.wait
    result: st.result
    error: st.error
    success: st.success
    reset: (key = undefined) ->
      # seems to either reset given key or full state but not really, TODO: test and redocument
      if key && type(key) == 'string' && !st.error?.meta?[key] then return
      cs always {}
    call: callFn

# Lets you call an async function with the abibility to throw and handle results as state
# eg. useCall -> ... or useCall {successDelay: 2000}, -> ...
export useCall = (optionsOrCall, callOrUndefined) ->
  asyncCall = if callOrUndefined then callOrUndefined else optionsOrCall
  options = if callOrUndefined then optionsOrCall else {}

  _useCall {...options, asyncCall}