import _test from "ramda/es/test"; #auto_require: _esramda
import {$} from "ramda-extras" #auto_require: esramda-extras

import React from 'react'

import {useFela} from 'setup'




toMask = (mask) ->
	if mask == 'number' then return /^[\d\.,]+$/
	else return mask

export default Textbox = ({s, kind = 'box', type = 'text', mask, onChange, onEnter, onKeyDown, error, value,
	...rest}) ->
	sBase = 'outgyc-2 fo(outgyc-8_2) bord0 bgwh xg1 fabka7-14 p10_15 _fade3 _textboxPlaceholder'
	sError = if error then 'outrec_3 fo(outrec_3)' else ''

	maskRE = mask && toMask mask

	if kind == 'box'
		sKind = "_sh6"
	else if kind == 'soft'
		sKind = 'br4'

	onChangeSelf = (e) ->
		if mask
			if e.target.value != '' && !_test maskRE, e.target.value
				e.preventDefault()
				return

		onChange?(e.target.value, e)

	_ 'input', {s: "#{sBase} #{sKind} #{sError} #{s}", type, spellCheck: 'false', onChange: onChangeSelf,
	value: value || '',
	onKeyDown: (e) ->
		if e.keyCode == 13 then onEnter?()
		onKeyDown?(e)
	...rest}
