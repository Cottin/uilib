import React from 'react'

import BounceLoader from 'react-spinners/BounceLoader'
import Link from './Link2'

import {useFela, colors} from 'setup'

export default Button = ({s, sWrapper, kind = 'login', look = 'default', color, scale = 1.0, wait, onClick,
  disabled, href, children, className, ...rest}) ->
  # declare the className but skip it since s is the way to use it
  sBase = "curp _fade2 useln whn"

  fSize = Math.round 15 * scale
  pvSize = Math.round 8 * scale
  phSize = Math.round 25 * scale

  if kind == 'login'
    sKind = "br22 p15_22 w100% #{!disabled && 'hofo(scale1.02 out0)'}"
    sWrapperBase = 'xccc xg1 mb4'
    bounceSize = 32
    if wait then sWait = 'br50% xrcc wauto w50'

    if look == 'default'
      sLook = "bgbue fawh7-15 #{disabled && 'bgbue-4 fo(outbue-6_3)' || 'hofo(_sh5)'}"
      spinnerClr = 'wh'
    else if look == 'link'
      sLook = 'fabka-77-15 bg0 mb0 hofo(bgbue-1)'
      spinnerClr = 'bue'
    else if look == 'outline'
      sLook = 'outgyc-3 fabka-86-15 bg0 hofo(_sh5 outbue_3)'
      spinnerClr = 'bue'

  else if kind == 'pill'
    sWrapperBase = ''
    sKind = "br22 p10_30 #{!disabled && 'hofo(scale1.02 out0)'}"
    bounceSize = 22
    if wait then sWait = 'br50% xrcc p10_20'

    if look == 'default'
      sLook = "bggna fawh7-16 #{disabled && 'bgbue-4 fo(outbue-6_3)' || 'hofo(_sh5)'}"
      spinnerClr = 'wh'

  else if kind == 'rounded'
    sWrapperBase = ''
    sKind = "br4 p#{pvSize}_#{phSize} #{!disabled && 'hofo(scale1.02 out0)'}"
    bounceSize = 22
    if wait then sWait = 'br50% xrcc p10_20'

    clr = 'gna'
    if color == 'sea' then clr = 'gn'
    else if color == 'azure' then clr = 'bue'
    else if color == 'coral' then clr = 'rec'

    if look == 'default'
      sLook = "bg#{clr} fawh7-#{fSize} #{disabled && 'op0.3' || 'hofo(_sh5)'}"
      spinnerClr = 'wh'

    else if look == 'text'
      sLook = "bg0 fabk-67-#{fSize} op0.5 #{disabled && 'op0.3' || 'hofo(op1)'}"
      spinnerClr = 'wh'

  else if kind == 'small'
    sWrapperBase = ''
    sKind = 'p3_10 op0.3'
    bounceSize = 22
    if wait then sWait = 'br50% xrcc p10_20'

    if look == 'discreet'
      sLook = "fabk-57-12 bg0 #{!disabled && 'hofo(op1 scale1.02 out0)'}"
      spinnerClr = 'wh'


  onClickSelf = (e) ->
    if wait || disabled then return e.preventDefault()
    onClick? e

  onSubmit = (e) ->
    if wait then e.preventDefault()

  extra = {onClick: onClickSelf}
  if rest.type == 'submit' then extra.onSubmit = (e) -> if wait then e.preventDefault()

  inner = 
    _ 'button', {s: "#{sBase} #{sKind} #{sLook} #{sWait} #{s}", ...extra, ...rest},
      if !wait then children
      else
        _ Fragment,
          _ {}, '\u00A0'
          _ {s: 'posa'}, 
            _ BounceLoader, {color: colors(spinnerClr), loading: true, size: bounceSize}

  if href
    _ Link, {href},
      _ 'a', {href, s: "#{sWrapperBase} #{sWrapper}"}, inner
  else
    _ {s: "#{sWrapperBase} #{sWrapper}"}, inner


