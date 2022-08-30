import isEmpty from "ramda/es/isEmpty"; import map from "ramda/es/map"; #auto_require: esramda
import {mapI, sumBy, $} from "ramda-extras" #auto_require: esramda-extras

import React from 'react'

import {_} from 'setup'

import {useChangeState} from './reactUtils'


# Converts an angle expressed in percent to radians
percentToRad = (percent) -> Math.PI * 2 * percent / 100

# Converts an angle expressed in percent to x,y coordinates and scales it
percentToCoords = (percent, scale) ->
	rad = percentToRad percent
	{x: Math.cos(rad) * scale, y: Math.sin(rad) * scale}

# In css 0deg or 0% is up (x=0, y=1), in coordinate systems and trigonometry 0deg is out to the right (x=1, y=0).
# This converts a percent from the css world to the trigonometric world
cssPercentToMath = (percent) ->
	polPercent = percent - 25
	if polPercent < 0 then polPercent += 100
	return polPercent

# Converts x and y in coordinate system to css position starting in the top left corner
coordsToPosition = (cx, cy) ->
	{x: (1 + cx) / 2, y: (1 + cy) / 2}

# Converts an angle from positive x-axis -180 to 180 to a css percentage 0-100% starting from positive y-axis
angleToCssPercent = (degree) ->
	cssDegree = null
	if degree > 0 && degree < 90 then cssDegree = 90 - degree # 0 - 90
	else if degree < 0 then cssDegree = 90 - degree # 90 - 270
	else if degree > 0 && degree > 90 then cssDegree = 180 - degree + 270

	return cssDegree / 360 * 100

# Returns x, y, radius, angle from positive x-axis and angle in percentage from positive y-axis (for css)
getPosition = (e) ->
	# Note: e.nativeEvent.offsetX uses inner circle so need to use clientX - rect.left
	rect = e.currentTarget.getBoundingClientRect()
	offsetX = e.clientX - rect.left
	offsetY = e.clientY - rect.top
	x = offsetX - e.currentTarget.offsetWidth / 2
	y = -1 * offsetY + e.currentTarget.offsetHeight / 2
	radius = Math.sqrt x*x + y*y
	# old = Math.atan(y / x) * (180 / Math.PI);
	# https://stackoverflow.com/a/15994225/416797
	angleRad = Math.atan2(y, x) # angle between line (0, 0) -> (x, y) and positive x-axis (0, 0) -> (1, 0)
	angleDegree = angleRad * 180 / Math.PI
	cssPercent = angleToCssPercent angleDegree
	return [x, y, radius, angleDegree, cssPercent]

# Pie chart component
# onHover: (item) -> # get called when new item is hovered
# hilight: (item) -> return (item.id == forcedHilightedId) # force a hilight without hovering
# e.g.
#   items = [{value: 142, color: '#00ff00', hoverColor: '#00cc00'}, ...]
export default Pie = ({s, items, Label, children, onHover = null, hilight = null}) ->
	[st, cs, rs] = useChangeState {degree: null, radius: null, x: null, y: null}
	childRef = React.useRef null
	selfRef = React.useRef null
	hoveredRef = React.useRef null
	hoveredChangedRef = React.useRef false

	totalValue = $ items || [], sumBy (i) -> i.value
	gradient = []
	totalPercent = 0

	data = []

	for item in items || []
		percentFrom = totalPercent
		itemPercent = item.value / totalValue * 100
		totalPercent += itemPercent
		percentTo = totalPercent
		percent = percentFrom + (percentTo - percentFrom) / 2
		mathPercent = cssPercentToMath percent

		childRadius = childRef.current?.firstChild.getBoundingClientRect().width / 2
		selfRadius = selfRef.current?.getBoundingClientRect().width / 2

		color = item.color
		hoverdByMouse = st.percent >= percentFrom && st.percent <= percentTo && st.radius > childRadius && st.radius < selfRadius
		if hoverdByMouse
			if hoveredRef.current != item
				hoveredRef.current = item
				hoveredChangedRef.current = true
			color = item.hoverColor
		else if hilight? item
			color = item.hoverColor

		labelRadious = (((selfRadius - childRadius) / 2) + childRadius) / selfRadius

		coords = percentToCoords mathPercent, labelRadious
		position = $ coordsToPosition(coords.x, coords.y), map (n) -> n * 100

		data.push {...item, position, percent: Math.round itemPercent}

		gradient.push "#{color} 0 #{totalPercent}%"

	mouseMove = (e) ->
		[x, y, radius, degree, cssPercent] = getPosition e
		# Item being hovered is now calulated in for-loop in render. Calling onHover from there causes react warning.
		# Work around by introducing hoveredChangedRef flag. Another solution could be to calc things outside of render.
		if hoveredChangedRef.current
			onHover hoveredRef.current
			hoveredChangedRef.current = false
		cs {x, y, radius, percent: cssPercent}

	mouseOut = () ->
		if hoveredRef.current then onHover null
		hoveredRef.current = null
		rs()

	_ {s: s + 'w100% pt100% br50% xrcc z2 sh0_1_3_0_bk-4 posr ho(scale1.05) _fade1', ref: selfRef,
	style: {background: if isEmpty gradient then _.colors('beb-5') else "conic-gradient(#{gradient.join ', '})"},
	onMouseMove: if onHover then mouseMove
	onMouseOut: if onHover then mouseOut},
		Label && $ data, mapI (item, i) -> 
			# _ {s: "posa lef#{position.x}% top#{position.y}% w20% h20% ml-10% mt-10% xccc"}
				# _ Label, item
			_ {s: "fawh5-11 posa lef#{item.position.x}% top#{item.position.y}% w20% h20% ml-10% mt-10% xccc", key: i},
				_ Label, item
		_ {s: 'posa top0 lef0 br50% h100% w100% xccc', ref: childRef},
			children
