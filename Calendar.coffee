import _includes from "ramda/es/includes"; import _join from "ramda/es/join"; import _map from "ramda/es/map"; import _toUpper from "ramda/es/toUpper"; import _type from "ramda/es/type"; import _without from "ramda/es/without"; #auto_require: _esramda
import {$, isNilOrEmpty} from "ramda-extras" #auto_require: esramda-extras

import React, {useState, useEffect} from 'react'
import {Flipper, Flipped} from 'react-flip-toolkit'

import SVGarrow from 'icons/arrow.svg'

import {useFela} from 'setup'

import {df} from 'comon/shared'


months = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]

formatMonth = (date) -> 
	sYear = if df.format('YYYY', Date.now()) != date.substring(0, 4) then ' ' + date.substring(0, 4) else ''
	return df.format('MMMM', date) + sYear

isRange = (selected) -> _type(selected) == 'Array'
isMulti = (selected) -> _type(selected) == 'Set'

# Calendar was built to test a strategy to animate periods that might not be continous as a prototype for
# skyviews in Time.
# Eg. Animating from [2020, 2021, 2022] to [2021, 2022, 2023] is quite obvious since you just use the years
#	for flipKey as "2021,2022,2023" and also the years for flipId's.
# It's trickier to go from [2020, 2021, 2022] to [2025, 2026, 2027] since if you use the years for flipId's
# none of the new years [2025, 2026, 2027] has been rendered already so they will just appear without being
# animated.
# One solution could be to first render 2025, 2026 and 2027 to the right and then animate them in, but it's
# unnessecary renderings and will require two render step.
# The chosen solution is to always render 3 panels with arbitrary flipId's (starting from -1, 0, 1). If you
# want the panels to animate left you just add 1 and to animate right subtract 1.
# The content of the panels is not tied to the flipId's, but instead we keep a list of what content should
# actually be rendered in the years array. [null, 2021, null] means 2021 is rendered in the middle and both
# the left and right panels are empty. If we want to increase 1 year we just add 1 to the arbitrary items
# so the panels animate left and setYears to [2021, 2022, null].
# If we want to move many years we do the same; add 1 to items and setYears to [2021, 2026, null] to see the
# animation from 2021 to 2026.
# It seems to work well, but not yet tested on weeks in skyview.
# NOTE: It is possible to render 5 items so if scrolling many units, render a dummy inbetween so that if feels
#	like it's scrolling more than just the same amout as 1 year. To try it out, check commit of 2023-10-22 but
# it felt like too much was scrolling so decided to not use that idea.
export default Calendar = ({s, mode = 'month', double = false, selected, marked, look, onChange, onClick, className, scale = 1.0, dev = false}) ->
	[items, setItems] = useState if double then [-2, -1, 0, 1, 2, 3] else [-1, 0, 1] # arbitrary items to enable animation
	[hoveredDate, setHoveredDate] = useState null # needed to keep track of range hover

	isYear = mode == 'year'
	isMonth = mode == 'month'
	if isYear
		startUnit = selected && parseInt(df.format('YYYY', selected)) || parseInt(df.format('YYYY', Date.now()))
	else if isMonth
		if isRange selected then dateToStart = selected[0]
		else if isMulti selected then dateToStart = Array.from(selected)[0]
		else dateToStart = selected

		if !dateToStart && marked?.length > 0 then dateToStart = marked[0]
		startUnit = df.yyyymmdd(df.startOf('month', dateToStart || Date.now()))
		if double then startUnit2 = df.add 1, 'month', startUnit

	[units, setUnits] = useState if double then [null, null, startUnit, startUnit2, null, null] else [null, startUnit, null]

	useEffect () ->
		if isMulti selected then return # not yet implemented
		if isRange selected then return # not yet implemented
		if double then return # not yet implemented

		if isNilOrEmpty selected then return

		# If selected changes, scroll it into view
		if isYear then newUnit = parseInt df.format('YYYY', selected)
		else if isMonth then newUnit = df.startOf 'month', selected

		if newUnit == units[1] then # do nothing
		else if newUnit == units[2] then rightClick()
		else if newUnit == units[0] then leftClick()
		else if newUnit < units[1]
			setUnits [null, newUnit, units[1]]
			animateLeft()
		else if newUnit > units[1]
			setUnits [units[1], newUnit, null]
			animateRight()

	, [selected]

	flipKey = $ items, _map((x) -> x), _join(',')

	size = 250 * scale
	width = size
	if double then width = width * 2
	stiffness = dev && 30 || 230

	addToUnit = (delta, unit) ->
		if isYear then unit + delta
		else if isMonth then df.add delta, 'month', unit


	animateLeft = () -> setItems $ items, _map (x) -> x - 1
	animateRight = () -> setItems $ items, _map (x) -> x + 1

	leftClick = () ->
		if double then setUnits [null, null, addToUnit(-1, units[2]), units[2], units[3], null]
		else setUnits [null, addToUnit(-1, units[1]), units[1]]
		animateLeft()

	rightClick = () ->
		if double then setUnits [null, units[2], units[3], addToUnit(1, units[3]), null, null]
		else setUnits [units[1], addToUnit(1, units[1]), null]
		animateRight()

	onClickDate = (date) -> 
		if isRange selected
			[start, end] = selected
			if start && end then onChange [date, null]
			else if start
				if date < start then onChange [date, null]
				else onChange [start, date]
			else
				onChange [date, null]
		else if isMulti selected
			if selected.has date then onChange new Set _without [date], Array.from(selected)
			else onChange new Set [...selected, date]
		else
			onChange?(date)

	onHoverDate = (date) ->
		setHoveredDate date

	onMouseLeave = () ->
		setHoveredDate null


	extraHight = isMonth && 1.1 || 1.0

	if look == 'beige'
		clr = {bg1: 'wh', bg2: 'wh', bg3: 'bun', bg4: 'bun-3', bg5: 'bun-3', ho1: 'bk-1', tx1: 'bk-6', tx2: 'bk-4', tx3: 'bk-6', tx4: 'bk', tx5: 'wh', ar: 'bk-3', sh: '_sh6', bo1: 'bun<1'}
	else
		clr = {bg1: 'buc>1', bg2: 'buc-9', bg3: 'buc<1', bg4: 'buc-9', bg5: 'wh-2', ho1: 'buc<1-9', tx1: 'wh-9', tx2: 'wh-4', tx3: 'wh-8', tx4: 'wh', tx5: 'wh', ar: 'wh-8', sh: '_sh1', bo1: 'buc<1'}

	_ {s: "w#{width} h#{size*extraHight} #{clr.sh} bg#{clr.bg1} br6 xc__ #{!dev && 'ovh'} #{s}", className, onClick},
		_ {s: "xrcc bg#{clr.bg2} #{isYear && 'h25%' || 'h20%'} posr"},
			_ {s: "ho(bg#{clr.ho1}) br6 xrcc p#{double && 1 || 3}% curp posa lef#{double && 1 || 5}%", onClick: leftClick},
				_ SVGarrow, {s: "w#{scale * 28} fill#{clr.ar} rot90"}
			if double
				_ {s: "fa#{clr.tx1}7-#{Math.ceil scale*18} useln xr_c w100%"},
					_ {s: 'w50% xrcc'}, if isMonth then formatMonth units[2]
					_ {s: 'w50% xrcc'}, if isMonth then formatMonth units[3]
			else
				_ {s: "fa#{clr.tx1}7-#{Math.ceil scale*18} useln"},
					if isYear then units[1]
					else if isMonth then formatMonth units[1]
			_ {s: "ho(bg#{clr.ho1}) br6 xrcc p#{double && 1 || 3}% curp posa rig#{double && 1 || 5}%", onClick: rightClick},
				_ SVGarrow, {s: "w#{scale * 28} fill#{clr.ar} rot270"}

		_ {s: 'xg1 xc__ w100%', onMouseLeave},
			_ Flipper, {flipKey, spring: {stiffness, damping: 23}, className: 'flipperBase'},
				items.map (item, idx) ->
					_ Flipped, {key: item, flipId: item, onMouseLeave},
						if isMonth
							_ Month, {month: units[idx], double, selected, marked, onClickDate, onHoverDate,
							hovered: hoveredDate, scale, clr, dev}
						else if isYear
							_ Year, {year: units[idx], selected, marked, onClickDate, scale, dev}

Year = ({year, selected, onClickDate, scale, dev, ...flippedProps}) ->
	_ {s: 'w33.33% xg1 xc__ posr', ...flippedProps},
		if year
			_ {s: 'p5% xrbcw xg1'},
				$ months, _map (month) ->
					_ YearMonth, {key: month, year, month, selected, onClickDate, scale, dev}

YearMonth = ({year, month, selected, onClickDate, scale, dev}) ->
	date = df.yyyymmdd "#{year}-#{month}-01"
	isSelected = df.isSame date, selected, 'month'
	sSelected = isSelected && 'bgbuc<1 fawh ho(bgbuc<1)'
	text = _toUpper(df.format 'MMM', date) + if dev then date[3] else ''
	_ {s: "w24% h32% xrcc tac fawh-87-#{Math.ceil scale*13} useln ho(bgbuc-9 fawh) br6 curp #{sSelected}",
	onClick: () -> onClickDate date}, text

#########################################################

vmMonth = ({month}) ->
	firstDay = df.startOf 'week', month
	lastDay = df.endOf 'week', df.endOf('month', month)
	day = df.startOf 'week', month
	days = []
	while day <= lastDay
		days.push {date: day, sText: df.format('D', day), half: !df.isSame(month, day, 'month')}
		day = df.add 1, 'day', day

	return {days}


Month = ({month, double, selected, marked, onClickDate, onHoverDate, hovered, scale, clr, dev, ...flippedProps}) ->
	_ {s: "w#{double && '16.66%' || '33.33%'} xg1 xc__ posr", ...flippedProps},
		if month
			vm = vmMonth {month}
			_ {s: 'p5% xr__w xg1'},#, style: {alignContent: 'start'}},
				$ vm.days, _map (day) ->
					_ Day, {key: day.date, date: day.date, text: day.sText, half: day.half, showHalf: !double,
					selected, marked, onClickDate, onHoverDate, hovered, scale, clr}

Day = ({date, text, half, showHalf = true, onClickDate, onHoverDate, hovered, selected, marked, scale, clr}) ->
	if half && !showHalf then return _ {s: "w#{100/7}% h#{100/6}%"}

	white = if half then 'wh-6' else 'wh'
	if isRange selected
		[start, end] = selected
		if start == end == date then sSel = "bg#{clr.bg3} fa#{white} ho(bg#{clr.bg3})"
		else if start == date then sSel = "bg#{clr.bg3} fa#{white} ho(bg#{clr.bg3}) br4_0_0_4"
		else if end == date then sSel = "bg#{clr.bg3} fa#{white} ho(bg#{clr.bg3}) br0_4_4_0"
		else if start < date && date < end then sSel = "bg#{clr.bg4} fa#{white} br0"
		else if start && !end && date > start
			if date < hovered then sSel = "bg#{clr.bg4} fa#{white} br0"
			else if date == hovered then sSel = "bg#{clr.bg4} fa#{white} br0_4_4_0"
	else if isMulti selected
		sSel = selected.has(date) && "bg#{clr.bg3} fa#{clr.tx5} ho(bg#{clr.bg3} fa#{clr.tx5})"
	else
		sSel = selected && selected == date && "bg#{clr.bg3} fawh ho(bg#{clr.bg3})"


	if marked && _includes date, marked then sMarked = "bord#{clr.bo1}"

	extra = if isRange selected then {onMouseOver: () -> onHoverDate date} else {}

	# _ {s: "w#{100/7}% h#{100/6}% br4 xg1 xrcc tac fawh-#{half && 4 || 8}7-#{Math.ceil scale*13} 
	_ {s: "w#{100/7}% h#{100/6}% br4 xg1 xrcc tac fa#{half && clr.tx2 || clr.tx3}7-#{Math.ceil scale*13} 
	ho(bg#{clr.bg4} fa#{clr.tx4}) #{sSel} #{sMarked} curp useln", ...extra, onClick: () -> onClickDate date},
		if getToday() == date
			_ {s: "br50% h80% w80% xrcc bg#{clr.bg5}"}, text
		else text

cached = null
getToday = () -> if cached then cached else df.yyyymmdd(Date.now())
