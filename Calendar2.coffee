import __ from "ramda/es/__"; import _join from "ramda/es/join"; import _map from "ramda/es/map"; import _type from "ramda/es/type"; #auto_require: _esramda
import {$} from "ramda-extras" #auto_require: esramda-extras

import React, {useState, useEffect} from 'react'
import {Flipper, Flipped} from 'react-flip-toolkit'

import {css, cva} from '@/styled-system/css'

import SVGarrow from 'icons/arrow.svg'

import {df, capitalize} from 'comon/shared'


months = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]

formatMonth = (date) -> 
	sYear = if df.format('YYYY', Date.now()) != date.substring(0, 4) then ' ' + date.substring(0, 4) else ''
	return df.format('MMMM', date) + sYear

isRange = (selected) -> _type(selected) == 'Array'
isMulti = (selected) -> _type(selected) == 'Set'

	# 	clr = {bg1: 'wh', bg2: 'wh', bg3: 'bun', bg4: 'bun-3', bg5: 'bun-3', ho1: 'bk-1',
	# 	tx1: 'bk-6', tx2: 'bk-4', tx3: 'bk-6', tx4: 'bk', tx5: 'wh', tx6: 'bk-3',
	# 	ar: 'bk-3', sh: '_sh6', bo1: 'bun<10', mtMonth: '-0.5%'}
	# else
	# 	clr = {bg1: 'buc>10', bg2: 'buc-9', bg3: 'buc<10', bg4: 'buc-9', bg5: 'wh-2', ho1: 'buc<10-9',
	# 	tx1: 'wh-9', tx2: 'wh-4', tx3: 'wh-8', tx4: 'wh', tx5: 'wh', tx6: 'wh-4',
	# 	ar: 'wh-8', sh: '_sh1', bo1: 'buc<10', mtMonth: '0'}
shortpandaTheme =
	beige:
		bg1: 'bgwh'
		bg2: 'bgwh'
		bg5: 'bgbun-3'
		sh1: '_sh6'
		sel: "bgbun fawh"
		ar: 'fillbk-3'
		tx1: 'fabk-6__'
		tx2: 'fabk-4'
		tx3: 'fabk-6'
		tx6: 'fabk-3'
		mtMonth: 'mt-0.5%'
	blue:
		bg1: 'bgbuc>10'
		bg2: 'bgbuc-9'
		bg5: 'bgwh-2'
		sh1: '_sh1'
		sel: "bgbuc<10 fawh"
		ar: 'fillwh-8'
		tx1: 'fawh-9__'
		tx2: 'fawh-4'
		tx3: 'fawh-8'
		tx6: 'fawh-4'
		mtMonth: 'mt0'

export default Calendar = ({s, style, mode = 'month', double = false, selected, marked, look, onChange, onClick, onDateClick, className,
	dev = false, theme = 'beige'}) ->

	[items, setItems] = useState if double then [-2, -1, 0, 1, 2, 3] else [-1, 0, 1] # arbitrary items to enable animation
	[hoveredDate, setHoveredDate] = useState null # needed to keep track of range hover

	abbreviatedDays = $ [1, 2, 3, 4, 5, 6, 7], _map (i) -> df.dayjs().day(i).format('dd')

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

	flipKey = $ items, _map((x) -> x), _join(',')

	# _ {s: ""}, 'te1'
	# return 'test1'

	width = 250
	height = 262
	if double then width = width * 2

	extraHight = isMonth && 1.1 || 1.0

	# _ {s: "w#{width} h#{size*extraHight} #{th.sh1} bg#{th.bg1} br6 xc__ #{!dev && 'ovh'} #{s}", className, onClick}, 'test'
		# _ {s: "xrcc bg#{clr.bg2} #{isYear && 'h25%' || 'h20%'} posr"},

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
		onDateClick?(date)

		# if isRange selected
		# 	[start, end] = selected
		# 	if start && end then onChange [date, null]
		# 	else if start
		# 		if date < start then onChange [date, null]
		# 		else onChange [start, date]
		# 	else
		# 		onChange [date, null]
		# else if isMulti selected
		# 	if selected.has date then onChange new Set _without [date], Array.from(selected)
		# 	else onChange new Set [...selected, date]
		# else
		# 	onChange?(date)

	onHoverDate = (date) ->
		# setHoveredDate date

	onMouseLeave = () ->
		# setHoveredDate null

	onMonthClick = (monthStart) ->
		# onChange [monthStart, df.endOf 'month', monthStart]

	stiffness = dev && 30 || 230

	_ {s: "w250 h262 #{th.sh1} bg#{th.bg1} br6 xc__ #{!dev && 'ovh'} #{s}", className, onClick, style},
		_ {s: "xrcc #{th.bg2} #{isYear && 'h25%' || 'h20%'} posr"},
			_ {s: "br6 xrcc #{double && 'p1% lef1%' || 'p3% lef5%'} curp posa", onClick: leftClick},
				_ SVGarrow, {s: "w28 fill#{th.ar} rot90"}

			if double
				# _ {s: "fa#{clr.tx1}7-#{Math.ceil scale*18} useln xr_c w100%"},
				# 	if isRange
				# 		_ Fragment, {},
				# 			_ {s: 'w50% xrcc'},
				# 				_ 'span', {s: 'curp ho(tdu)', onClick: -> onMonthClick units[2]}, if isMonth then formatMonth units[2]
				# 			_ {s: 'w50% xrcc'},
				# 				_ 'span', {s: 'curp ho(tdu)', onClick: -> onMonthClick units[3]},  if isMonth then formatMonth units[3]
				# 	else
				# 		_ Fragment, {},
				# 			_ {s: 'w50% xrcc'}, if isMonth then formatMonth units[2]
				# 			_ {s: 'w50% xrcc'}, if isMonth then formatMonth units[3]
			else
				_ {s: "fabk7-18 #{th.tx1} useln"},
					if isYear then units[1]
					else if isMonth then formatMonth units[1]
			_ {s: "br6 xrcc #{double && 'p1% rig1%' || 'p3% rig5%'} curp posa", onClick: rightClick},
				_ SVGarrow, {s: "w28 #{th.ar} rot270"}

		_ {s: 'xg1 xc__ w100%', onMouseLeave},
			_ Flipper, {flipKey, spring: {stiffness, damping: 23}, className: 'flipperBase'},
				items.map (item, idx) ->
					_ Flipped, {key: item, flipId: item, onMouseLeave},
						if isMonth
							_ Month, {theme, month: units[idx], double, selected, marked, onClickDate, onHoverDate,
							hovered: hoveredDate, dev}
						else if isYear
							_ {}, 'b'
							# _ Year, {year: units[idx], selected, marked, onClickDate, scale, dev}


abbreviatedDaysCache = null

# We can't calculate days too early because application needs chance to call df.setLocale(...)
# but we also don't want to re-calculate this every render or in every instance of Calendar
getAbbreviatedDays = ->
	if !abbreviatedDaysCache
		abbreviatedDaysCache = [1, 2, 3, 4, 5, 6, 7].map (i) -> df.dayjs().day(i).format('dd')
	return abbreviatedDaysCache

vmMonth = ({month}) ->
	firstDay = df.startOf 'week', month
	lastDay = df.endOf 'week', df.endOf('month', month)
	day = df.startOf 'week', month
	days = []
	while day <= lastDay
		days.push {date: day, sText: df.format('D', day), half: !df.isSame(month, day, 'month')}
		day = df.add 1, 'day', day

	return {days}

Month = ({theme, month, double, selected, marked, onClickDate, onHoverDate, hovered, dev, ...flippedProps}) ->
	_ {s: "#{double && 'w16.66%' || 'w33.33%'} xg1 xc__ posr #{th.mtMonth}", ...flippedProps},
		if month
			vm = vmMonth {month}
			_ {s: 'p5% xr__w xg1'}, #, style: {alignContent: 'start'}},
				$ getAbbreviatedDays(), _map (day) -> _ DayLabel, {key: day, day, theme}
				$ vm.days, _map (day) ->
					_ Day, {key: day.date, theme, date: day.date, text: day.sText, half: day.half, showHalf: !double,
					selected, marked, onClickDate, onHoverDate, hovered}

DayLabel = ({day, theme}) ->
	# 100/7 = 14.28
	_ {s: "w14.28% h14.28% xg1 xrcc tac fa_7-12 #{th.tx6} useln"}, day

Day = ({theme, date, text, half, showHalf = true, onClickDate, onHoverDate, hovered, selected, marked}) ->
	if half && !showHalf then return _ {s: "w14.28% h16.66%"}

	white = if half then 'wh-6' else 'wh'
	if isRange selected
		# [start, end] = selected
		# if start == end == date then sSel = "bg#{clr.bg3} fa#{white} ho(bg#{clr.bg3})"
		# else if start == date then sSel = "bg#{clr.bg3} fa#{white} ho(bg#{clr.bg3}) br4_0_0_4"
		# else if end == date then sSel = "bg#{clr.bg3} fa#{white} ho(bg#{clr.bg3}) br0_4_4_0"
		# else if start < date && date < end then sSel = "bg#{clr.bg4} fa#{white} br0"
		# else if start && !end && date > start
		# 	if date < hovered then sSel = "bg#{clr.bg4} fa#{white} br0"
		# 	else if date == hovered then sSel = "bg#{clr.bg4} fa#{white} br0_4_4_0"

		# sWeekend = if df.dayOfWeek(date) >= 5 && !(start <= date && end >= date) then 'op0.5' else ''
	else if isMulti selected
		# sSel = selected.has(date) && "bg#{clr.bg3} fa#{clr.tx5} ho(bg#{clr.bg3} fa#{clr.tx5})"
		# sWeekend = if df.dayOfWeek(date) >= 5 && !(selected.has(date)) then 'op0.5' else ''
	else
		# sSel = selected && selected == date && "bg#{clr.bg3} fawh ho(bg#{clr.bg3})"
		# sWeekend = if df.dayOfWeek(date) >= 5 && selected != date then 'op0.5' else ''

	sWeekend = ''
	sSel = ''
	sMarked = ''
	extra = {}

	isSelected = isMulti(selected) && selected.has(date)


	# if marked && _includes date, marked then sMarked = "#{th.bo1}"

	# extra = if isRange selected then {onMouseOver: () -> onHoverDate date} else {}

	_ {s: "w14.28% h14.28% br4 #{sWeekend} xg1 xrcc tac fa_7-13 #{half && th.tx2 || th.tx3}
	#{sSel} #{sMarked} curp useln
	#{isSelected && th.sel}
	", ...extra, onClick: () -> onClickDate date},
		if getToday() == date
			_ {s: "br50% h80% w80% xrcc bg#{th.bg5}"}, text
		else text

cached = null
getToday = () -> if cached then cached else df.yyyymmdd(Date.now())
