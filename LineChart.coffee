import _isNil from "ramda/es/isNil"; import _mergeDeepRight from "ramda/es/mergeDeepRight"; import _pluck from "ramda/es/pluck"; #auto_require: _esramda
import {mapI, maxIn, $} from "ramda-extras" #auto_require: esramda-extras

import React from 'react'
import {motion} from "framer-motion"

import {useFela, colors} from 'setup'


addPadding = (percentage, padding = 5) ->
	return padding + percentage * (100 - 2 * padding) / 100

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
			fontSize: '1.2rem'
			fill: colors('bk-6')
			fontWeight: 600
		hover:
			scale: 1.1
			translateY: '-1%'
			fontWeight: 700
	valueSelected:
		default:
			scale: 1.1
			translateY: '-1%'
			fontWeight: 700


export default LineChart = ({data, max, s, look: userLook = {}, onClick}) ->
	look = _mergeDeepRight defaultLook, userLook

	len = data.length
	maxToUse = if !_isNil max then max else maxIn(_pluck('value', data)) * 1.05

	perY = (point, skip) -> addPadding(100 - 100 * (point / maxToUse), 14) + if skip then 0 else '%'
	perX = (idx, skip) -> addPadding(100 * (idx / (len-1)), 5) + if skip then 0 else '%'

	itemWidth = 100 / len

	points = $ data, mapI ({value, label, selected}, idx) ->
		if idx > 0
			lastValue = data[idx-1].value
			line = {y1: perY(lastValue), y2: perY(value), x1: perX(idx-1), x2: perX(idx)}

		{cy: perY(value), cx: perX(idx), value, label, selected, line,
		valueY: perY(value, true) - 5 + '%'
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

	_ {s: "bgwh h100% xrbe posr #{s}"},
		_ 'svg', {s: "h100% w100% posa z0 _fade1"},

			$ points, mapI ({line}, idx) ->
				if line
					{y1, y2, x1, x2} = line
					_ motion.line, {key: idx, animate: {y1, y2, x1, x2, opacity: 1}, initial: {y1, y2, x1, x2, opacity: 0},
					transition: {ease: "easeOut"}, ...look.line.default}


			$ points, mapI ({cx, cy, valueY, value, label, rectX, line, selected}, idx) ->

				_ motion.g, {key: idx, whileHover: 'hover', s: 'curp',
				onClick: -> onClickPoint {cx, cy, valueY, value, label, rectX, line, selected, idx}},

					_ motion.rect, {width: itemWidth+'%', height: '100%', animate: {x: rectX, opacity: 1,
					...(selected && vars.rectSelected.default || vars.rect.default)},
					initial: {x: rectX, opacity: 0}, y: 0, s: '_fade1', fill: 'rgba(0, 0, 0, 0)',
					variants: selected && vars.rectSelected || vars.rect}

					_ motion.circle, {animate: {cx, cy, opacity: 1,
					...(selected && vars.circleSelected.default || vars.circle.default)},
					initial: {cx, cy, opacity: 0}, transition: {ease: "easeOut"},
					variants: selected && vars.circleSelected || vars.circle}

					_ motion.text, {animate: {x: cx, y: valueY, opacity: 1,
					...(selected && vars.valueSelected.default || vars.value.default)},
					transition: {ease: "easeOut"}, textAnchor: "middle", alignmentBaseline: "middle",
					initial: { x: cx, y: valueY, opacity: 0},
					variants: selected && vars.valueSelected || vars.value}, value

					_ motion.text, {animate: {x: cx, y: addPadding(100, 8)+'%', opacity: 1, fill: colors('bk-6')},
					initial: {x: cx, y: addPadding(100, 8)+'%', opacity: 0}, transition: {ease: "easeOut"},
					textAnchor: "middle", alignmentBaseline: "middle", s: 'fabk-37-13'}, label
					


