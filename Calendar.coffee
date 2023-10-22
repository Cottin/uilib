import _join from "ramda/es/join"; import _map from "ramda/es/map"; import _toUpper from "ramda/es/toUpper"; #auto_require: _esramda
import {$} from "ramda-extras" #auto_require: esramda-extras

import React, {useState, useEffect} from 'react'
import {Flipper, Flipped} from 'react-flip-toolkit'

import SVGarrow from 'icons/arrow.svg'

import {useFela} from 'setup'

import {df} from 'comon/shared'


months = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]

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
export default Calendar = ({selected, onChange, scale = 1.0, dev = false}) ->
	[items, setItems] = useState [-2, -1, 0, 1, 2] # arbitrary items to enable animation
	startYear = selected && parseInt(df.format('YYYY', selected)) || parseInt(df.format('YYYY', Date.now()))
	[years, setYears] = useState [null, null, startYear, null, null]

	useEffect () ->
		# If selected changes, scroll it into view
		newYear = parseInt df.format('YYYY', selected)

		if newYear == years[2] then # do nothing
		else if newYear == years[3] then rightClick()
		else if newYear == years[1] then leftClick()
		else if newYear < years[2]
			setYears [null, null, newYear, newYear+1, years[2]]
			animateLeft 2
		else if newYear > years[2]
			setYears [years[2], newYear-1, newYear, null, null]
			animateRight 2

	, [selected]

	flipKey = $ items, _map((x) -> x), _join(',')

	size = 250 * scale
	stiffness = dev && 30 || 230

	

	animateLeft = (steps = 1) -> setItems $ items, _map (x) -> x - steps
	animateRight = (steps = 1) -> setItems $ items, _map (x) -> x + steps

	leftClick = () ->
		setYears [null, null, years[2]-1, years[2], null]
		animateLeft()

	rightClick = () ->
		setYears [null, years[2], years[2]+1, null, null]
		animateRight()

	onClick = (date) -> 
		onChange?(date)

	_ {s: "w#{size} h#{size} bgbuc-9 br6 xc__ #{!dev && 'ovh'}"},
		_ {s: 'xrac bgbuc-9 h25% br6'},
			_ {s: 'ho(bgbuc<1-9) br6 xrcc p3% curp', onClick: leftClick},
				_ SVGarrow, {s: "w#{scale * 28} fillwh-8 rot90"}
			_ {s: "fawh-97-#{Math.ceil scale*18} useln"}, years[2]
			_ {s: 'ho(bgbuc<1-9) br6 xrcc p3% curp', onClick: rightClick},
				_ SVGarrow, {s: "w#{scale * 28} fillwh-8 rot270"}

		_ Flipper, {flipKey, spring: {stiffness, damping: 23}, className: 'flipperBase'},
			items.map (item, idx) ->
				_ Flipped, {key: item, flipId: item},
					_ Year, {year: years[idx], selected, onClick, scale, dev}

Year = ({year, selected, onClick, scale, dev, ...flippedProps}) ->
	_ {s: 'w33.33% xg1 xc__ posr', ...flippedProps},
		if year
			_ {s: 'p5% xrbcw xg1'},
				$ months, _map (month) ->
					_ Month, {key: month, year, month, selected, onClick, scale, dev}

Month = ({year, month, selected, onClick, scale, dev}) ->
	date = df.yyyymmdd "#{year}-#{month}-01"
	isSelected = df.isSame date, selected, 'month'
	sSelected = isSelected && 'bgbuc<1 fawh ho(bgbuc<1)'
	text = _toUpper(df.format 'MMM', date) + if dev then date[3] else ''
	_ {s: "w24% h32% xrcc tac fawh-87-#{Math.ceil scale*12} useln ho(bgbuc-9 fawh) br6 curp #{sSelected}",
	onClick: () -> onClick date}, text
