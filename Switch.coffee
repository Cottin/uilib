import React from 'react'


import {useFela, colors} from 'setup'


export default Switch = ({s, value, onChange, look = 'default', scale = 1}) ->
  base = 20 * scale
  sBase = "br#{base / 1.5} curp h#{base * 1} w#{base * 2} p2 xrsc _fade1"

  if look == 'default'
    sValue = value && 'bggn' || 'bgbue-1'
  else if look == 'dark'
    sValue = value && 'bggn' || 'bgwh-4'

  # _ {s: s + "#{sBase} #{sValue}", tabIndex: 1, onClick: -> onChange !value},
  #   _ {s: "bgwh _fade1 _shSwitch h#{base * 0.9} w#{base * 0.9} br50%",
  #   style: {transform: "translateX(#{value && '100%' || 0})"}}

  _ {s: 'posr'},
    _ 'input', {type: 'checkbox', s: "op0 w1 h1 posa top0", className: 'switchInput', checked: value,
      onChange: -> onChange !value}
    _ {s: "#{sBase} #{sValue} #{s}", className: 'switchBg', onClick: -> onChange !value},
      _ {s: "bgwh _fade1 _shSwitch h#{base * 0.9} w#{base * 0.9} br50%",
      style: {transform: "translateX(#{value && '100%' || 0})"}}
