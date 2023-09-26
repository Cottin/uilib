import React from 'react'

import BounceLoader from 'react-spinners/BounceLoader'

import {useFela, colors} from 'setup'

export default Button = ({s, sWrapper, kind = 'login', look = 'default', color, scale = 1.0, wait, onClick,
  disabled, children, className, href, ...rest}) ->

  if href then throw new Error 'href no longer supported in Button, use LinkButton'

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
      sLook = "bggna fawh7-16 #{disabled && 'bggna-4 fo(outgna-6_3)' || 'hofo(_sh5)'}"
      spinnerClr = 'wh'
    else if look == 'red'
      sLook = "bgrec fawh7-16 #{disabled && 'bgrec-4 fo(outrec-6_3)' || 'hofo(_sh5)'}"
      spinnerClr = 'wh'
    else if look == 'blue'
      sLook = "bgbue fawh7-16 #{disabled && 'bgbue-4 fo(outbue-6_3)' || 'hofo(_sh5)'}"
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

  else if kind == 'link'
    sWrapperBase = ''
    sKind = "p0 lh110%"
    bounceSize = 15
    if wait then sWait = 'br50% xrcc borb0'


    if look == 'default'
      sLook = "fabuk-67-#{fSize} borbbuk-2 bg0 #{disabled && 'op0.3' || 'ho(fabuk borbbuk-7)'}"
      spinnerClr = 'buk'


  onClickSelf = (e) ->
    if wait || disabled then return e.preventDefault()
    onClick? e

  onSubmit = (e) ->
    if wait then e.preventDefault()

  extra = {onClick: onClickSelf}
  if rest.type == 'submit' then extra.onSubmit = (e) -> if wait then e.preventDefault()


  _ {s: "#{sWrapperBase} #{sWrapper}"},
    _ 'button', {s: "#{sBase} #{sKind} #{sLook} #{sWait} #{s}", ...extra, ...rest},
      if !wait then children
      else
        _ Fragment,
          _ {}, '\u00A0'
          _ {s: 'posa'}, 
            _ BounceLoader, {color: colors(spinnerClr), loading: true, size: bounceSize}

  # Added LinkButton and removed href to make it more DRY.
  # Keeping this for now but remove if this seems to work
  # inner = 
  #   _ 'button', {s: "#{sBase} #{sKind} #{sLook} #{sWait} #{s}", ...extra, ...rest},
  #     if !wait then children
  #     else
  #       _ Fragment,
  #         _ {}, '\u00A0'
  #         _ {s: 'posa'}, 
  #           _ BounceLoader, {color: colors(spinnerClr), loading: true, size: bounceSize}

  # if href
  #   _ Link, {href, s: "#{sWrapperBase} #{sWrapper}"}, inner
  #     # _ {s: "#{sWrapperBase} #{sWrapper}"}, inner
  # else
  #   _ {s: "#{sWrapperBase} #{sWrapper}"}, inner


