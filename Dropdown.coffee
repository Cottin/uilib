import _equals from "ramda/es/equals"; import _filter from "ramda/es/filter"; import _has from "ramda/es/has"; import _indexOf from "ramda/es/indexOf"; import _isEmpty from "ramda/es/isEmpty"; import _test from "ramda/es/test"; import _type from "ramda/es/type"; #auto_require: _esramda
import {$} from "ramda-extras" #auto_require: esramda-extras

import React, {useState, useLayoutEffect, useRef} from 'react'

import SVGarrow from 'icons/arrow.svg'
import {useFela} from 'setup'

import {useOuterClick} from './reactUtils'

KEY = {DOWN: 40, UP: 38, ENTER: 13, SPACE: 32, ESCAPE: 27, TAB: 9}

getText = (item) -> item.text || item.name || _type(item) == 'String' && item

getKey = (item) ->
	if _has 'id', item then item.id
	else if _has 'key', item then item.key
	else getText item

defaultFilterItem = (item, text) ->
	if _isEmpty text then return true
	propToUse = getText item
	return _test(new RegExp("^#{text}", 'i'), propToUse)


export default Dropdown = ({s, selected, onChange, items, placeholder = '\u00A0', error, openAtStart = false,
autoComplete = false, filterItem = defaultFilterItem,
renderItem, renderSelected}) ->
	[isOpen, setIsOpen] = useState openAtStart
	[idx, setIdx] = useState null
	[text, setText] = useState ''
	ref = useRef null
	useOuterClick ref, -> close()
	refItems = useRef null
	filteredItems = if autoComplete then $ items, _filter (item) -> filterItem item, text else items
	refText = useRef null


	useLayoutEffect () ->
		if refItems.current
			{top, height} = refItems.current.getBoundingClientRect()
			windowHeight = window.innerHeight || document.documentElement.clientHeight
			overflow = windowHeight - (top + height)
			availableAbove = top
			if overflow < 0 && overflow * -1 < availableAbove
				refItems.current.style.top = 'unset'
				refItems.current.style.bottom = '100%'

		return undefined
	, [isOpen]

	close = (focus) ->
		setIdx null
		setIsOpen false
		if focus # option to refocus
			setTimeout (() -> ref.current?.focus()), 0

	open = (idx = 0) ->
		setIsOpen true
		if autoComplete
			setText ''
			setIdx idx
			focusText()
		else if !selected 
			setIdx idx

	focusText = () ->
		setTimeout (() -> refText.current?.focus()), 0


	onClick = () ->
		console.log 'onClick main (will close)'
		if isOpen
			close()
		else
			setIsOpen true
			if autoComplete
				setText ''
				setIdx 0
				focusText()

	onClickItem = (item, idx) ->
		onChange item, idx

	onKeyDown = (e) ->
		if e.keyCode == KEY.DOWN
			if isOpen == false then open 0
			else
				if idx == null
					if selected
						selIdx = _indexOf selected, filteredItems
						if selIdx == filteredItems.length - 1 then setIdx selIdx
						else setIdx selIdx + 1
					else setIdx 0
				else if idx < filteredItems.length - 1 then setIdx idx + 1

			e.preventDefault()

		else if e.keyCode == KEY.UP
			if isOpen == false then open filteredItems.length - 1
			else
				if idx == null
					if selected
						selIdx = _indexOf selected, filteredItems
						if selIdx == 0 then setIdx selIdx
						else setIdx selIdx - 1
				else if idx > 0 then setIdx idx - 1
			e.preventDefault()

		else if e.keyCode == KEY.ENTER || e.keyCode == KEY.SPACE
			if isOpen
				if idx != null then onChange filteredItems[idx], idx
				close true
			else
				open 0

		else if e.keyCode == KEY.ESCAPE || e.keyCode == KEY.TAB
			if isOpen then close()


		if autoComplete then e.stopPropagation() # stop so it's not also handled in button a second time


	sError = if error then 'outrec_3 fo(outrec_3)'

	onChangeText = (e) ->
		setText e.currentTarget.value
		setIdx 0

	onClickText = (e) ->
		e.stopPropagation() # stop so not closed from buttons onClick handler

	# Prefer a to button since button's onClick gets triggered by pressing ENTER or SPACE while it's selected.
	# It gets hard to reason about when onClick is actually triggered in autoComplete vs not

	_ 'a', {s: "fabk-77-14 p10_15 outgyc-2 pr35 fo(outgyc-8_2 fabk-8) #{sError} _fade1 bgwh br4
	xr_c curp ho(bggyd fabk-8) hoc1(fillbk-8) posr #{s}",
	onClick, onKeyDown, ref, tabIndex: 0},
		_ SVGarrow, {s: 'w20 fillbk-4 posa rig7%', className: 'c1'}

		if autoComplete && isOpen
			_ Fragment,
				_ 'input', {s: 'bord0 out0 bg0 posa w100% h100% lef0 top0 fabk-77-14 p10_15', type: 'text',
				ref: refText, value: text, onKeyDown, onChange: onChangeText, onClick: onClickText,
				autoFocus: openAtStart}
				_ {s: 'vish'}, '.'
		else if !selected then _ {s: 'fabk-36-14 fsi useln'}, placeholder
		else _ {s: 'useln whn ovh'}, renderSelected?({selected}) || getText selected

		if filteredItems && isOpen
			_ {s: 'posa lef0 top100% bgwh iw100% _sh1 z3 mt1 tal', ref: refItems},
				filteredItems.map (item, i) ->
					sIdx = idx == i && 'bggyb-5'
					isSelected = !autoComplete && _equals(selected, item)
					sSel = isSelected && "bgbue fawh ho(bgbue<1) #{idx == i && 'bgbue<1'}"
					sItem = "p10_20 ho(bggyb-5) #{sIdx} #{sSel} _fade3 useln whn"
					onClickFn = -> onClickItem item, i
					if renderItem?
						renderItem({item, idx, i, s: sItem, isSelected, onClick: onClickFn})
					else
						_ {s: sItem, key: getKey(item), onClick: onClickFn}, getText item


