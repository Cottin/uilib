import React from 'react'

import BounceLoader from 'react-spinners/BounceLoader'
import Link from 'next/link'

import {_} from 'setup'


export default Button = ({s, kind = 'login', look = 'default', wait, onClick, disabled, href, children, ...rest}) ->
  sBase = "curp _fade2 useln whn"

  if kind == 'login'
    sKind = "br22 p15_22 w100% #{!disabled && 'hofo(scale1.02 out0)'}"
    sWrapper = 'xccc xg1 mb4'
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
    sWrapper = ''
    sKind = "br22 p10_30 #{!disabled && 'hofo(scale1.02 out0)'}"
    bounceSize = 22
    if wait then sWait = 'br50% xrcc p10_20'

    if look == 'default'
      sLook = "bggna fawh7-16 #{disabled && 'bgbue-4 fo(outbue-6_3)' || 'hofo(_sh5)'}"
      spinnerClr = 'wh'

  else if kind == 'rounded'
    sWrapper = ''
    sKind = "br4 p8_25 #{!disabled && 'hofo(scale1.02 out0)'}"
    bounceSize = 22
    if wait then sWait = 'br50% xrcc p10_20'

    if look == 'default'
      sLook = "bggna fawh7-15 #{disabled && 'op0.3' || 'hofo(_sh5)'}"
      spinnerClr = 'wh'

    else if look == 'text'
      sLook = "bg0 fabk-57-15 op0.5 #{disabled && 'op0.3' || 'hofo(op1)'}"
      spinnerClr = 'wh'

  else if kind == 'small'
    sWrapper = ''
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
    _ 'button', {s: s + "#{sBase} #{sKind} #{sLook} #{sWait}", ...extra, ...rest},
      if !wait then children
      else
        _ React.Fragment, {},
          _ {}, '\u00A0'
          _ {s: 'posa'}, 
            _ BounceLoader, {color: _.colors(spinnerClr), loading: true, size: bounceSize}

  if href
    _ Link, {href},
      _ 'a', {href, s: sWrapper}, inner
  else
    _ {s: sWrapper}, inner


