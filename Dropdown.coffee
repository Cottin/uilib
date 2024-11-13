import _any from "ramda/es/any"; import _equals from "ramda/es/equals"; import _filter from "ramda/es/filter"; import _has from "ramda/es/has"; import _indexOf from "ramda/es/indexOf"; import _isEmpty from "ramda/es/isEmpty"; import _isNil from "ramda/es/isNil"; import _test from "ramda/es/test"; import _type from "ramda/es/type"; #auto_require: _esramda
import {$, sf0} from "ramda-extras" #auto_require: esramda-extras

import React, {useState, useLayoutEffect, useRef, forwardRef, useImperativeHandle} from 'react'

import SVGarrow from 'icons/arrow.svg'
import SVGcross from 'icons/crossFat.svg'
import {useFela} from 'setup'

import {useOuterClick, useOuterMouseDown} from './reactUtils'

getText = (item) ->
	if _isNil(item) then ''
	else item.text || item.name || _type(item) == 'String' && item || _type(item) == 'Number' && item || item.id

defaultGetKey = (item) ->
	if _has 'id', item then item.id
	else if _has 'key', item then item.key
	else getText(item) || sf0 item

defaultFilterItem = (item, text) ->
	if _isEmpty text then return true
	propToUse = getText item
	return _test(new RegExp("^#{text}", 'i'), propToUse)

defaultFilterGroup = (group, text) ->
	return $ group.items, _any (item) -> defaultFilterItem item, text


DefaultItem = ({item, isMarked, isSelected, i, onClick}) ->
	sMarked = isMarked && 'bggyb-5'
	sSel = isSelected && "bgbue fawh ho(bgbue<10) #{isMarked && 'bgbue<10'}"
	_ {s: "p10_20 ho(bggyb-5) #{sMarked} #{sSel} _fade3 useln whn", 'data-i': i, onClick},
		getText item

DefaultGroup = ({group}) ->
	_ {s: 'p10_20 curd bggyb-7'}, getText(group) || 'Group 1'

DefaultEmpty = ({}) ->
	_ {s: 'p10_20 fabk-47-14 fsi curd'}, 'No options'

DefaultPlaceholder = ({placeholder}) ->
	_ {s: "fabk-36-14 fsi useln"}, placeholder

DefaultSelected = ({selected}) ->
	_ {s: "useln whn ovh"}, getText selected


# NOTE: render props, eg. renderItem causes hook error with styleSetup/fela so use Component props for now
export default Dropdown = forwardRef ({s, sOpen, selected, onChange, items, onTextChange, placeholder = '\u00A0', error,
openAtStart = false, onClose, autoComplete = false, onKeyDown, filterItem = defaultFilterItem,
findSelectedIdx = _indexOf, isItemSelected = _equals, groupBy, tabIndex = 0,
getKey = defaultGetKey, disabled, onEnter, Item = DefaultItem, Group = DefaultGroup, Empty = DefaultEmpty,
Placeholder = DefaultPlaceholder, Selected = DefaultSelected, blockOuterClick = false}, externalRef) ->
	[isOpen, setIsOpen] = useState openAtStart
	[idx, setIdx] = useState null
	[text, setText] = useState ''
	[autoCompleteFake, setAutoCompleteFake] = useState null
	ref = useRef null
	refStopPropagation = useRef null
	useOuterClick ref, (e) ->
		if refStopPropagation.current
			e.stopPropagation()
			refStopPropagation.current = false
	useOuterMouseDown ref, (e) ->
		if isOpen && blockOuterClick
			refStopPropagation.current = true
			e.stopPropagation()

	refItems = useRef null
	if _isNil items then throw new Error 'items cannot be nil'
	if autoComplete == 'async' then filteredItems = items
	else if autoComplete then filteredItems = $ items, _filter (item) -> filterItem item, text 
	else filteredItems = items

	refText = useRef null

	useImperativeHandle externalRef, () ->
		openAndFocus: () ->
			setIsOpen true
			setTimeout () ->
				console.log 'focus from external', refText.current
				refText.current?.focus()
			, 0
		resetAutoComplete: () ->
			setAutoCompleteFake null
		close: (focus) ->
			close focus

	

	###### DYNAMIC POSITIONING #################################################################################
	calcPosition = (itemsEl, dropdownEl) ->
		HEIGHT_OF_DROPDOWN = 20
		iel = itemsEl.getBoundingClientRect()
		windowHeight = window.innerHeight || document.documentElement.clientHeight
		del = dropdownEl.getBoundingClientRect()
		availableAbove = del.top
		availableBelow = windowHeight - del.bottom
		overflowAbove = Math.round iel.height - availableAbove
		overflowBelow = Math.round iel.height - availableBelow
		fitsAbove = overflowAbove <= 0
		fitsBelow = overflowBelow <= 0
		return {availableAbove, availableBelow, overflowAbove, overflowBelow, fitsAbove, fitsBelow}

	setAbove = (itemsEl) -> itemsEl.style.top = 'unset'; itemsEl.style.bottom = '102%'
	setBelow = (itemsEl) -> itemsEl.style.top = '100%'; itemsEl.style.bottom = 'unset'

	useLayoutEffect () ->
		if refItems.current && ref.current && isOpen
			pos = calcPosition refItems.current, ref.current
			if pos.fitsBelow
				setBelow refItems.current
			else 
				if pos.fitsAbove
					setAbove refItems.current
				else if pos.availableAbove >= 1.7 * pos.availableBelow # Doesn't fit but much more space above
					setAbove refItems.current
					refItems.current.style.height = pos.availableAbove - 10 + 'px'
				else
					setBelow refItems.current
					refItems.current.style.height = pos.availableBelow - 10 + 'px'

		return undefined
	, [isOpen]

	useLayoutEffect () ->
		if refItems.current && ref.current && isOpen
			idxItem = refItems.current.querySelector("[data-i=\"#{idx}\"]");
			console.log 'idxItem', idxItem
			idxItem?.scrollIntoView({ behavior: 'instant', block: 'nearest', inline: 'start' })
		return undefined
	, [idx]

	useLayoutEffect () ->
		if refItems.current && ref.current && isOpen
			heightIsSet = !!refItems.current.style.height
			isPositionedAbove = refItems.current.style.top == 'unset'
			pos = calcPosition refItems.current, ref.current
			scrollHeight = refItems.current.scrollHeight
			if isPositionedAbove
				if scrollHeight <= pos.availableAbove then refItems.current.style.height = null
				else refItems.current.style.height = pos.availableAbove - 10 + 'px'
			else
				if scrollHeight <= pos.availableBelow then refItems.current.style.height = null
				else refItems.current.style.height = pos.availableBelow - 10 + 'px'

		return undefined
	, [sf0 filteredItems]

	############################################################################################################

	close = (focus) ->
		setIdx null
		setIsOpen false
		onClose?()
		if focus # option to refocus
			setTimeout (() -> ref.current?.focus()), 0

	open = (startIdx = null, skipAuto = false) ->
		setIsOpen true
		if selected
			selIdx = findSelectedIdx selected, filteredItems
			setIdx selIdx
		else
			if !_isNil startIdx then setIdx startIdx
			else if autoComplete then setIdx 0
			else # dont set idx

		if autoComplete && !skipAuto
			setText ''
			console.log 'selected', selected
			if selected
				setAutoCompleteFake getText selected
				selectText()
				onTextChange? getText selected
			else
				focusText()

	focusText = () ->
		setTimeout (() -> refText.current?.focus()), 0

	selectText = () ->
		setTimeout () ->
			refText.current?.select()
			refText.current?.focus()
		, 0

	onClick = () ->
		if disabled then return
		if isOpen then close()
		else
			setIsOpen true
			open()

	onClickItem = (item, idx, e) ->
		onChange item, idx
		close true
		e.stopPropagation()

	onKeyDownSelf = (e) ->
		if disabled then return
		if e.key == 'ArrowDown'
			if isOpen == false then open 0
			else
				if idx == null then setIdx 0
				else if idx < filteredItems.length - 1 then setIdx idx + 1

			e.preventDefault()

		else if e.key == 'ArrowUp'
			if isOpen == false then open filteredItems.length - 1
			else
				if idx == null then setIdx filteredItems.length - 1
				else if idx > 0 then setIdx idx - 1
			e.preventDefault()

		else if e.key == 'Enter' || e.key == ' '
			if isOpen
				if e.key == ' ' && autoComplete then return
				else
					if idx != null then onChange filteredItems[idx], idx
					close true
			else
				if e.key == 'Enter' && onEnter then onEnter()
				else
					open 0
			e.preventDefault()

		else if e.key == 'Escape'
			if isOpen then close true

		else if e.key == 'Tab'
			if isOpen then close()

		else if e.key == 'Delete' || e.key == 'Backspace'
			if !isOpen then onChange null

		else if e.key.length == 1
			if autoComplete && isOpen == false
				open 0, true
				if autoCompleteFake then setAutoCompleteFake null
				setText e.key
				focusText()

		else
			if !isOpen then onKeyDown?(e)

		if autoComplete then e.stopPropagation() # stop so it's not also handled in button a second time

	onBlur = (e) ->
		# Vimium steals the escape when a textbox is focused causing onKeyDown not to fire.
		# The obvious solution would be to not care but at the same time this onBlur on the parent seems stable
		if ref.current && !ref.current.contains(e.relatedTarget)
			if isOpen then close()

	sError = if error then 'outrec_3 fo(outrec_3)'

	onChangeText = (e) ->
		if autoCompleteFake then setAutoCompleteFake null
		if autoComplete && e.currentTarget.value == ''
			onChange null
		setText e.currentTarget.value
		setIdx 0
		onTextChange? e.currentTarget.value

	onClickText = (e) ->
		e.stopPropagation() # stop so not closed from buttons onClick handler

	unSelect = () ->
		onChange null
		setAutoCompleteFake null
		close true

	# Prefer a to button since button's onClick gets triggered by pressing ENTER or SPACE while it's selected.
	# It gets hard to reason about when onClick is actually triggered in autoComplete vs not

	sBase = if disabled then "bggyd fabk-5 fo(outgyc-8_2)" else "bgwh ho(bggyd fabk-8) fo(outbun_2 fabk-8) curp"

	_ 'a', {s: "fabk-77-14 p10_15 outgyc-2 pr35 #{sError} _fade1 br4
	xr_c #{sBase} hoc1(fillbk-8) posr #{s}", onBlur,
	onClick, onKeyDown: onKeyDownSelf, ref, tabIndex},
		_ SVGarrow, {s: 'w20 fillbk-4 posa rig12', className: 'c1'}

		if autoComplete && isOpen
			textToUse = text
			if autoCompleteFake then textToUse = autoCompleteFake
			_ Fragment,
				_ 'input', {s: 'bord0 out0 bg0 posa w100% h100% lef0 top0 fabk-77-14 p10_15', type: 'text',
				ref: refText, value: textToUse, onKeyDown: onKeyDownSelf, onChange: onChangeText, onClick: onClickText,
				autoFocus: openAtStart}
				_ {s: 'vish'}, '.'
		else if !selected then _ Placeholder, {placeholder}
		else _ Selected, {selected}

		if isOpen
			lastGroup = null
			_ {s: "posa lef0 top100% bgwh iw100% _sh1 z3 mt1 tal ova #{sOpen}", ref: refItems},
				if filteredItems.length == 0 then _ Empty, {}
				else
					filteredItems.map (item, i) ->
						isMarked = idx == i 
						isSelected = isItemSelected(selected, item)
						itemProps = {item, idx, i, isSelected, isMarked, text, unSelect,
						onClick: (e) -> onClickItem item, i, e}
						if groupBy
							group = groupBy item
							if !_equals group, lastGroup
								lastGroup = group
								_ Fragment, {key: JSON.stringify(group)+getKey(item)},
									_ Group, {group}
									_ Item, itemProps
							else
								_ Item, {key: getKey(item), ...itemProps}
						else
							_ Item, {key: getKey(item), ...itemProps}


