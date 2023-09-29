import React from 'react'

import BounceLoader from 'react-spinners/BounceLoader'

import {useFela, colors} from 'setup'

import {Checkmark, Spinner} from './SVGs'

export default Button = ({s, sWrapper, kind, look = 'default', color, scale = 1.0, wait, success,
	onClick, disabled, children, className, href, ...rest}) ->

	style = {}

	if href then throw new Error 'href no longer supported in Button, use LinkButton'

	sButton = "posr p0 xrcc curp bg0"
	sBg = "br3 iw100% h100% posa z1"
	sChildren = "z2 posr"
	spinnerClr = 'wh'

	fSize = Math.round 15 * scale
	pvSize = Math.round 8 * scale
	phSize = Math.round 25 * scale


	if kind == 'login'
		sButton += " br22 w100% #{!disabled && 'hofo(scale1.02 out0)'} _fade1"
		sChildren += " br22 p15_22"
		sBg += " br22"

		if look == 'default'
			sButton += " #{disabled && 'fo(outbue-6_3)' || 'hofoc4(_sh5)'}"
			sBg += " #{disabled && 'bgbue-4' || 'bgbue'}"
			sChildren += " fawh7-15"

		else if look == 'link'
			sButton += " #{!disabled && 'hofoc4(bgbue-1)'}"
			sChildren += " fabka-76-15"

			spinnerClr = 'bue'

		else if look == 'outline'
			sButton += " #{!disabled && 'hofoc4(_sh5 outbue_3)'}"
			sBg += " outgyc-3"
			sChildren += " fabka-86-15 w100%"

			spinnerClr = 'bue'

	else if kind == 'pill'
		sButton += " br22 #{!disabled && 'hofo(scale1.02 out0)'} _fade1"
		sChildren += " br22 p10_30"
		sBg += " br22"

		if look == 'default'
			sButton += " #{!disabled && 'hofoc4(_sh5)'}"
			sBg += " bggna #{disabled && 'bggna-4'}"
			sChildren += " fawh7-16"
		else if look == 'red'
			sButton += " #{!disabled && 'hofoc4(_sh5)'}"
			sBg += " bgrec #{disabled && 'bgrec-4'}"
			sChildren += " fawh7-16"
		else if look == 'blue'
			sButton += " #{!disabled && 'hofoc4(_sh5)'}"
			sBg += " bgbue #{disabled && 'bgbue-4'}"
			sChildren += " fawh7-16"
		else if look == 'text'
			sButton += " #{!disabled && 'hofoc4(bggyb-3)'}"
			sChildren += " fabk-57-16 #{disabled && 'fabk-2'}"
			spinnerClr = 'bk-5'

	else if kind == 'rounded'
		sButton += " br4"
		sChildren += " br4 p#{pvSize}_#{phSize}"

		clr = 'gna'

		if color == 'sea' then clr = 'gn'
		else if color == 'azure' then clr = 'bue'
		else if color == 'coral' then clr = 'rec'

		if look == 'default'
			sBg += " bg#{clr} br4"
			sChildren += " fawh7-#{fSize}"
			if disabled then sButton += ' op0.3'
			else if !wait && !success then sButton += " hoc4(bg#{clr}<3)"

		else if look == 'text'
			sChildren += " fabk-67-#{fSize}"
			sButton += " op0.5"
			if disabled then sButton += ' op0.3'
			else if !wait && !success then sButton += " hofo(op1)"
			spinnerClr = 'bk-9'

	else if kind == 'small'
		sButton += " op0.3"
		sChildren += " p3_20 xrcc"
		spinnerClr = 'bk'

		if look == 'default'

		else if look == 'discreet'
			sButton += " #{!disabled && 'hofo(scale1.02 out0 op1)'} _fade1"
			sChildren += " fabk-57-12"

	else if kind == 'link'
		sButton += " #{disabled && 'op0.3'} _fade1"


		sKind = "lh110%"

		if look == 'default'
			sChildren += " fabuk-67-#{fSize} borbbuk-2 ho(fabuk borbbuk-7)"
			spinnerClr = 'buk'


	onClickSelf = (e) ->
		if wait || disabled || success then return e.preventDefault()
		onClick? e

	onSubmit = (e) ->
		if wait then e.preventDefault()

	extra = {onClick: onClickSelf}
	if rest.type == 'submit' then extra.onSubmit = (e) -> if wait then e.preventDefault()

	if wait || success then sChildren += " op0 pen"


	# Impossible to animate from width=100 to unset/auto (https://css-tricks.com/using-css-transitions-auto-dimensions/).
	# Easiest trick is animate min-width and we're setting min-width to 20 since it's probably small enough
	# for most cases but still big enough that if the child of sBg (Spinner/Checkmark) dissapears before
	# animating out again, the animation does not start from 0 but 20 and looks less bad.
	# Alternative would be min-width: 0 and use _ 'svg', {s: 'h100%', viewBox: "0 0 1 1"} as a placeholder
	# when Spinner/Checkmark is not shown, but we don't want unnessecary elements and current way good enough
	if wait || success
		sBg += " br50% iw20"


	_ 'button', {s: "#{sButton} #{s}", ...extra, ...rest},
		_ {s: sBg, className: "c4 spinnerBg #{success && 'spinnerScale'}"},
			if wait then _ Spinner, {s: 'p2', clr: spinnerClr}
			else if success then _ Checkmark, {s: 'h100%', clr: spinnerClr}

		_ {s: sChildren, className: 'c5'},
			children












