import React, {useRef, useLayoutEffect} from 'react'

import {useFela} from 'setup'



# Often in a modal or box the contents / views can change and it's nice to animate that change.
#
# Simples solution is to have _fade1 and hard coded heights for each view but obvious drawbacks.
#
# You could animate with react-flip-toolkit but seems overkill and after 2 hours of it still being buggy I
# gave up.
#
# There is a specific package react-animate-height (https://muffinman.io/react-animate-height/) but source
# looks very complex for a simple thing. The demo of auto height seems to work though.
# 
# This is an ultra simple solution that seems to work fine - so trying this out until proven wrong:
# https://codesandbox.io/s/react-animate-auto-height-1y5lz?file=/src/App.tsx:1016-1115

export default AnimateHeight = ({children, className, s}) -> 
  ref = useRef null

  useLayoutEffect () ->
    # Wrapping in raf because el.getBoundingClientRect() seems to be 0 in some cases otherwise
    rafId2 = undefined
    rafId = requestAnimationFrame () ->
      el = ref.current

      # get height of wrapper before everything happens
      oldHeight = el.getBoundingClientRect().height
      # if oldHeight == 0 then return

      # change height to auto to make browser calculate
      # get new calculated height
      # change it back to old before the browser realises what you did (i.e. before it re-paints)
      el.style.height = 'auto'
      newHeight = el.getBoundingClientRect().height
      el.style.height = "#{oldHeight}px"

      # wait for next paint
      # change height to the new value
      rafId2 = requestAnimationFrame () ->
        el.style.height = "#{newHeight}px"

    return () ->
      cancelAnimationFrame rafId
      if rafId2 then cancelAnimationFrame rafId2

  , [children, ref]

  # Used {overflow: "hidden"} before but seemed to work just fine without it so it was removed
  _ {ref, s: "#{s}", style: {transition: "height 250ms"}, className},
    children
