import _isEmpty from "ramda/es/isEmpty"; import _test from "ramda/es/test"; import _toLower from "ramda/es/toLower"; #auto_require: _esramda
import {} from "ramda-extras" #auto_require: esramda-extras

import React, {useEffect} from 'react'

import SVGarrow from 'icons/arrow.svg'
import {useFela} from 'setup'

import {countryList} from 'comon/shared/countries'

import Dropdown from './Dropdown'
import "/node_modules/flag-icons/css/flag-icons.custom.min.css"


filterItem = (item, text) ->
	if _isEmpty text then return true
	propToUse = item.name
	if _test(new RegExp("^#{text}", 'i'), propToUse) then true
	else if item.alias
		for ali in item.alias
			if _test(new RegExp("^#{text}", 'i'), ali) then return true
	else false


# NOTE: countries is ~4kb and flag-icons ~2kb gziped, could be smart to lazy load this component
# svgs are loaded individually but seems to be done when needed at render, make sure they do not get bundled.
export default DropdownCountry = ({selected, s, onChange, didLoad, ...rest}) ->

	# If you load this component lazily, supply didLoad so you can set a correct initial selected prop
	useEffect () ->
		didLoad? countryList 
	, []

	_ Dropdown, {placeholder: 'Select country', s, items: countryList, selected, autoComplete: true, onChange,
	...rest, filterItem, Item, Selected}



Item = ({item, idx, isSelected, i, onClick}) ->
	sIdx = idx == i && 'bggyb-5'
	sSel = isSelected && "bgbue fawh ho(bgbue<10) #{idx == i && 'bgbue<10'}"
	extra = if item.currencySymbol then " (#{item.currencySymbol})" else ''
	_ {s: "p10_20 ho(bggyb-5) #{sIdx} #{sSel} _fade3 useln whn", key: item.name+i, onClick},
		_ {s: 'xr_c'},
			# _ 'ul', {className: 'f16', s: 'mb0 p0 disi'},
			# 		_ 'li', {className: "flag flag__#{item.alpha2}"}
			# _ 'span', {className: "fi fi-#{item.alpha2}"}
			_ {s: 'w17 h13', className: "flagIconb flagIcon-#{_toLower item.alpha2}"}
			_ {s: 'ml8'}, "#{item.name}"

Selected = ({selected}) ->
	extra = if selected.currencySymbol then " (#{selected.currencySymbol})" else ''
	_ {s: 'xr_c'},
		_ {s: 'w17 h13 xs0', className: "flagIconb flagIcon-#{_toLower selected.alpha2 || ''}"}
		_ {s: 'ml8'}, "#{selected.name || '\u00A0'}"
