import _equals from "ramda/es/equals"; import _has from "ramda/es/has"; import _indexOf from "ramda/es/indexOf"; #auto_require: _esramda
import {} from "ramda-extras" #auto_require: esramda-extras

import React, {useState, useLayoutEffect, useRef} from 'react'

import SVGarrow from 'icons/arrow.svg'
import {useFela} from 'setup'

import {useOuterClick} from './reactUtils'

KEY = {DOWN: 40, UP: 38, ENTER: 13, SPACE: 32}


export default Dropdown = ({s, selected, onChange, items, placeholder = '\u00A0', error, scale = 1.0}) ->
	[open, setOpen] = useState false
	[idx, setIdx] = useState null
	ref = useRef null
	useOuterClick ref, -> close()
	refItems = useRef null

	useLayoutEffect () ->
		if refItems.current
			{top, height} = refItems.current.getBoundingClientRect()
			windowHeight = window.innerHeight || document.documentElement.clientHeight
			overflow = windowHeight - (top + height)
			if overflow < 0
				refItems.current.style.top = 'unset'
				refItems.current.style.bottom = '100%'

		return undefined

	close = () ->
		setIdx null
		setOpen false

	onClick = () ->
		if open then close() else setOpen true

	onClickItem = (item) ->
		onChange item

	getText = (item) -> item.text || item.name
	getKey = (item) ->
		if _has 'id', item then item.id
		else if _has 'key', item then item.key
		else getText item

	onKeyDown = (e) ->
		if e.keyCode == KEY.DOWN
			if open == false
				setOpen true
				if !selected then setIdx 0
			else
				if idx == null
					if selected
						selIdx = _indexOf selected, items
						if selIdx == items.length - 1 then setIdx selIdx
						else setIdx selIdx + 1
					else setIdx 0
				else if idx < items.length - 1 then setIdx idx + 1

			e.preventDefault()

		else if e.keyCode == KEY.UP
			if open == false
				setOpen true
				if !selected then setIdx items.length - 1
			else
				if idx == null
					if selected
						selIdx = _indexOf selected, items
						if selIdx == 0 then setIdx selIdx
						else setIdx selIdx - 1
				else if idx > 0 then setIdx idx - 1
			e.preventDefault()

		else if e.keyCode == KEY.ENTER || e.keyCode == KEY.SPACE
			if idx != null then onChange items[idx]
			# Note that we're not preventing default here since key up with Enter or Space triggers onClick
			# which handles open & close. (Not tested on windows / linux yet though)

	sError = if error then 'outrec_3 fo(outrec_3)'

	_ 'button', {s: "fabk-77-14 p10_15 outgyc-2 pr30px fo(outgyc-4 fabk-8) #{sError} _fade1 bgwh br4
	xr_c curp ho(bggyd fabk-8) hoc1(fillbk-8) posr #{s}",
	onClick, onKeyDown, ref},
		_ SVGarrow, {s: 'w20 fillbk-4 posa rig7%', className: 'c1'}
		if !selected then _ {s: 'fabk-36-14 fsi useln'}, placeholder
		else _ {s: 'useln whn ovh'}, getText selected

		if items && open
			_ {s: 'posa lef0 top100% bgwh iw100% _sh1 z3 mt1 tal', ref: refItems},
				items.map (item, i) ->
					sIdx = idx == i && 'bggyb-5'
					sSel = _equals(selected, item) && "bgbue fawh ho(bgbue<1) #{idx == i && 'bgbue<1'}"
					_ {s: "p10_20 ho(bggyb-5) #{sIdx} #{sSel} _fade3 useln whn", key: getKey(item),
					onClick: -> onClickItem item}, getText item

