import _isNil from "ramda/es/isNil"; import _length from "ramda/es/length"; import _map from "ramda/es/map"; import _mergeDeepRight from "ramda/es/mergeDeepRight"; import _mergeDeepWith from "ramda/es/mergeDeepWith"; import _pluck from "ramda/es/pluck"; import _reverse from "ramda/es/reverse"; import _type from "ramda/es/type"; #auto_require: _esramda
import {mapI, maxIn, $} from "ramda-extras" #auto_require: esramda-extras

import React from 'react'
import {motion} from "framer-motion"

import {useFela, colors} from 'setup'


addPadding = (percentage, paddingTop = 5, paddingBottom = 0) ->
	return paddingTop + percentage * (100 - (paddingTop + paddingBottom)) / 100

defaultLook =
	circle:
		default:
			stroke: 'white'
			fill: colors 'gya'
			strokeWidth: 3
			r: 7
		hover:
			fill: colors 'bue'
			r: 8
			transition: { duration: 0.1, ease: 'easeOut' }
	circleSelected:
		default:
			fill: colors 'bue'
			r: 8
		hover:
			fill: colors 'bue<1'
	line:
		default:
			stroke: colors('gyb')
			strokeWidth: '0.4rem'
	rect:
		default: {}
		hover:
			fill: colors 'bue-2'
	rectSelected:
		default:
			fill: colors 'bue-3'
		hover:
			fill: colors 'bue-4'
	value:
		default:
			fontSize: '1.4rem'
			fill: colors('bk-6')
			fontWeight: 600
		hover:
			scale: 1.1
			# translateY: '-1%'
			fontWeight: 700
	valueSelected:
		default:
			scale: 1.1
			fontSize: '1.4rem'
			# translateY: '-1%'
			fontWeight: 800

# Merges right but if right = userLook has an array to define different adaptations for different series in
# data, this function makes sure to merge the default look into every item in that array
mergeLook = (defaultLook, userLook) ->
	_mergeDeepWith specialMerge, defaultLook, userLook
	
specialMerge = (left, right) ->
	if _type(left) == 'Object' && _type(right) == 'Array'
		return $ right, _map (val) -> {...left, ...val}
	else
		return right


export default LineChart = ({data: dataProp, max, s, look: userLook = {}, onClick}) ->
	data = if _isNil dataProp then [] else dataProp
	look = mergeLook defaultLook, userLook

	len = maxIn _map(_length, data)
	if !_isNil max 
		maxToUse = max
	else
		maxes = $ data, _map(_pluck('value')), _map(maxIn)
		maxToUse = maxIn(maxes) * 1.05

	if maxToUse == 0 then maxToUse = 0.05

	perY = (point, skip) -> addPadding(100 - 100 * (point / maxToUse), 10, 16) + if skip then 0 else '%'
	perX = (idx, skip) -> addPadding(100 * (idx / (len-1)), 5, 5) + if skip then 0 else '%'

	itemWidth = 100 / len

	upOrDown = (listIdx, idx) ->
		amount = 6
		if data.length == 1 then return -1 * amount
		else if data.length == 2
			multiplier = -1
			otherListIdx = if listIdx == 0 then 1 else 0
			myPerY = perY(data[listIdx][idx].value, true)
			if data[otherListIdx][idx]?.value == null
				for nextIdx in [idx+1 ... data[otherListIdx].length]
					if data[otherListIdx][nextIdx]?.value != null
						for prevIdx in _reverse [0 ... idx]
							if data[otherListIdx][prevIdx]?.value != null
								fakeValue = (data[otherListIdx][nextIdx].value + data[otherListIdx][prevIdx].value) / 2
								otherPerY = perY(fakeValue, true)
								break

			else otherPerY = perY(data[otherListIdx][idx]?.value, true)
			if myPerY > 75 then return -1 * amount
			else if myPerY >= otherPerY then return amount + 1
			else return -1 * amount

		else throw new Error 'not yet implemented'

	pointsList = $ data, mapI (list, listIdx) ->
		skip = 0
		$ list, mapI ({value, sValue, label, selected}, idx) ->
			if idx > 0 && value != null
				lastIdx = idx-(1+skip)
				if lastIdx >= 0
					lastValue = list[lastIdx].value
					line = {y1: perY(lastValue), y2: perY(value), x1: perX(lastIdx), x2: perX(idx)}

			if value == null then skip++
			else skip = 0


			{cy: perY(value), cx: perX(idx), value, sValue, label, selected, line,
			valueY: perY(value, true) + upOrDown(listIdx, idx) + '%'
			rectX: (perX(idx, true) - (itemWidth/2)) + '%'}



	vars =
		value: look.value
		valueSelected: _mergeDeepRight look.value, look.valueSelected
		rect: look.rect
		rectSelected: _mergeDeepRight look.rect, look.rectSelected
		circle: look.circle
		circleSelected: _mergeDeepRight look.circle, look.circleSelected

	onClickPoint = (point) ->
		onClick? point

	_ {s: "bgwh h100% posr #{s}"},
		_ 'svg', {s: "h100% w100% posa z0 _fade1 ovv"},

			$ pointsList, mapI (points, listIdx) ->
				$ points, mapI ({line}, idx) ->
					if line
						{y1, y2, x1, x2} = line
						_ motion.line, {key: "#{listIdx}-#{idx}", animate: {y1, y2, x1, x2, opacity: 1},
						initial: {y1, y2, x1, x2, opacity: 0}, transition: {ease: "easeOut"}, ...look.line.default}

			$ pointsList, mapI (points, listIdx) ->
				stx = stxIdx listIdx
				$ points, mapI ({cx, cy, valueY, value, sValue, label, rectX, line, selected}, idx) ->
					if value == null then return null

					_ motion.g, {key: "#{listIdx}-#{idx}", whileHover: 'hover', s: 'curp',
					onClick: -> onClickPoint {cx, cy, valueY, value, label, rectX, line, selected, idx}},

						_ motion.circle, {animate: {cx, cy, opacity: 1,
						...(selected && stx(vars.circleSelected.default) || stx(vars.circle.default))},
						initial: {cx, cy, opacity: 0, r: 0, strokeWidth: 0}, transition: {ease: "easeOut"},
						variants: selected && stx(vars.circleSelected) || stx(vars.circle)}

						_ motion.text, {animate: {x: cx, y: valueY, opacity: 1,
						...(selected && stx(vars.valueSelected.default) || stx(vars.value.default))},
						transition: {ease: "easeOut"}, textAnchor: "middle", alignmentBaseline: "middle",
						initial: {x: cx, y: valueY, opacity: 0, fontWeight: 300},
						variants: selected && stx(vars.valueSelected) || stx(vars.value)}, !_isNil(sValue) && sValue || value

			$ pointsList[0], mapI ({cx, cy, valueY, value, sValue, label, rectX, line, selected}, idx) ->

				_ motion.g, {key: "0-#{idx}", whileHover: 'hover', s: 'curp',
				onClick: -> onClickPoint {cx, cy, valueY, value, label, rectX, line, selected, idx}},

					_ motion.rect, {width: itemWidth+'%', height: '100%', animate: {x: rectX, opacity: 1,
					...(selected && vars.rectSelected.default || vars.rect.default)},
					initial: {x: rectX, opacity: 0}, y: 0, s: '_fade1', fill: 'rgba(0, 0, 0, 0)',
					variants: selected && vars.rectSelected || vars.rect}

					_ motion.text, {animate: {x: cx, y: addPadding(100, 8, 8)+'%', opacity: 1, fill: colors('bk-6')},
					initial: {x: cx, y: addPadding(100, 8, 8)+'%', opacity: 0}, transition: {ease: "easeOut"},
					textAnchor: "middle", alignmentBaseline: "middle", s: 'fabk-37-14'}, label
					

stxIdx = (idx) -> (style) ->
	if _type(style) == 'Array' then style[idx] else style

