import equals from "ramda/es/equals"; import isEmpty from "ramda/es/isEmpty"; import map from "ramda/es/map"; #auto_require: esramda
import {mapI, sumBy, $, sf0} from "ramda-extras" #auto_require: esramda-extras

import React, {useRef, useState, useEffect, useCallback} from 'react'

import {useFela, colors} from 'setup'

import {useChangeState, memoDeep} from './reactUtils'


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
# hilight: (item) -> return (item.id == forcedHilightedId) # Having hard react problems with hilight, use hilighted instead
# e.g.
#   items = [{value: 142, color: '#00ff00', hoverColor: '#00cc00'}, ...]
export default Pie = React.memo ({s, s2, items, Label, children, onHover = null, hilighted = null, onClick, className}) ->
	childRef = React.useRef null
	selfRef = React.useRef null


	# Calculates data and gradient based on supplied mouse position
	calcState = (percent, radius) ->
		totalValue = $ items || [], sumBy (i) -> i.value
		gradient = []
		totalPercent = 0

		data = []
		idx = 0

		for item in items || []
			percentFrom = totalPercent
			itemPercent = if totalValue == 0 then 100 else item.value / totalValue * 100
			totalPercent += itemPercent
			percentTo = totalPercent
			realPercent = percentFrom + (percentTo - percentFrom) / 2
			mathPercent = cssPercentToMath realPercent

			childRadius = childRef.current?.firstChild.getBoundingClientRect().width / 2
			selfRadius = selfRef.current?.getBoundingClientRect().width / 2

			color = item.color
			hoverdByMouse = percent >= percentFrom && percent <= percentTo && radius > childRadius && radius < selfRadius

			if hoverdByMouse
				color = item.hoverColor
			else if hilighted == item.id
				color = item.hoverColor

			labelRadious = (((selfRadius - childRadius) / 2) + childRadius) / selfRadius

			coords = percentToCoords mathPercent, labelRadious
			position = $ coordsToPosition(coords.x, coords.y), map (n) -> n * 100

			data.push {...item, position, percent: Math.round(itemPercent), percentFrom, percentTo, idx: idx++}

			gradient.push "#{color} 0 #{totalPercent}%"

		return [data, gradient]

	[initialData, initialGradient] = calcState null, null
	# Note: don't keep mouse coords in state, it causes rerenders on mouse move
	# [state, setState] = useState {data: initialData, gradient: initialGradient}
	[data, setData] = useState initialData
	[gradient, setGradient] = useState initialGradient
	refGradient = useRef gradient # duplicate gradient to this ref for performance

	# Need to setState when item changes since component might start with empty items before data has loaded
	useEffect ->
		[newInitialData, newInitialGradient] = calcState null, null
		# setState {data: newInitialData, gradient: newInitialGradient}
		setData newInitialData
		setGradient newInitialGradient
		refGradient.current = newInitialGradient
		return undefined
	, [sf0 {items, hilighted}]


	getItem = (cssPercent) ->
		for item in data
			if item.percentFrom <= cssPercent && item.percentTo >= cssPercent then return item

	lastRan = useRef Date.now()

	mouseMove = useCallback (e) ->

		[x, y, radius, degree, cssPercent] = getPosition e
		[newData, newGradient] = calcState cssPercent, radius

		# It seems mouseMove sometimes get triggered so fast that the stateChange has not yet persisted and
		# didChange would be true causing unnessecery re-renders.
		# I experimented with throttling but did not work well.
		# This solution helps by keeping a ref updated with state and checking changed with that.
		didChange = !equals refGradient.current, newGradient

		if didChange
			refGradient.current = newGradient
			setData newData
			setGradient newGradient
			onHover? items[getItem(cssPercent)?.idx] 

	mouseOut = (e) ->
		[newData, newGradient] = calcState null, null
		refGradient.current = newGradient
		setData newData
		setGradient newGradient
		onHover null

	onClickSelf = (e) ->
		[x, y, radius, degree, cssPercent] = getPosition e
		idx = getItem(cssPercent)?.idx
		item = if isNaN idx then null else items[idx]
		onClick? item, e

	_ {s: "#{s} bgbe br50%"},
		_ {s: "w100% br50% xrcc z2 sh0_1_3_0_bk-4 posr ho(scale1.05) _fade1 #{s2}", ref: selfRef,
		style: {aspectRatio: '1/1',
		background: if isEmpty gradient then colors('beb-5') else "conic-gradient(#{gradient.join ', '})"},
		onMouseMove: if onHover then mouseMove
		onMouseOut: if onHover then mouseOut
		onClick: onClickSelf},
			Label && $ data, mapI (item, i) -> 
				if isNaN item.position.x then return 
				_ {s: "fawh5-11 posa lef#{item.position.x}% top#{item.position.y}% w20% h20% ml-10% mt-10% xccc", key: i},
					_ Label, item
			_ {s: 'posa top0 lef0 br50% h100% w100% xccc', ref: childRef},
				children
