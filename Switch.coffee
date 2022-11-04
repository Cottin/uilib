import React from 'react'


import {_} from 'setup'


export default Switch = ({s, value, onChange, scale = 1}) ->
  base = 20 * scale
  sBase = "br#{base / 1.5} curp h#{base * 1} w#{base * 2} p2 xrsc _fade1"
  sValue = value && 'bggn' || 'bgbue-1'

  # _ {s: s + "#{sBase} #{sValue}", tabIndex: 1, onClick: -> onChange !value},
  #   _ {s: "bgwh _fade1 _shSwitch h#{base * 0.9} w#{base * 0.9} br50%",
  #   style: {transform: "translateX(#{value && '100%' || 0})"}}

  _ {s: 'posr'},
    _ 'input', {type: 'checkbox', s: "op0 posa top0", className: 'switchInput', checked: value,
      onChange: -> onChange !value}
    _ {s: s + "#{sBase} #{sValue}", className: 'switchBg', onClick: -> onChange !value},
      _ {s: "bgwh _fade1 _shSwitch h#{base * 0.9} w#{base * 0.9} br50%",
      style: {transform: "translateX(#{value && '100%' || 0})"}}
