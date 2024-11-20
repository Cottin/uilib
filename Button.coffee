import React from 'react'

import {useFela, colors} from 'setup'

import {Checkmark, Spinner} from './SVGs'

export default Button = React.forwardRef ({s, sChildren: sChildrenProp, sBg: sBgProp, kind, look = 'default', color,
	scale = 1.0, wait, success, onClick, disabled, children, className, href, ...rest}, ref) ->

	style = {}

	if href then throw new Error 'href no longer supported in Button, use LinkButton'

	sButton = "posr p0 xrcc bg0 #{!disabled && 'curp'}"
	sBg = "br3 iw100% h100% posa xrcc"
	sChildren = "posr"
	spinnerClr = 'wh'
	sSpinner = ''
	sSuccess = 'h100%'

	fSize = Math.round 15 * scale
	pvSize = Math.round 8 * scale
	phSize = Math.round 25 * scale
	phSize1 = Math.round 18 * scale


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

	else if kind == 'hover'
		sButton += " br3 fabk-47-#{fSize} _fade1"
		sChildren += " br22 p#{pvSize}_#{phSize1}"

		if look == 'default'
			sButton += " #{!disabled && 'hofo(fabk-57-'+fSize+' out0) hofoc4(bggn)'}"
			if wait || success then sBg += " bggn"
		else if look == 'beige'
			sButton += " #{!disabled && 'hofo(bgbeb fabk-5 out0)'} _fade1"


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
			sButton += " br4 out0"
			sBg += " bg#{clr} br4"
			sChildren += " fawh7-#{fSize}"
			if disabled then sButton += ' op0.3'
			else if !wait && !success then sButton += " hofoc4(bg#{clr}<30)"

		else if look == 'text'
			sButton += " op0.5 out0"
			sChildren += " fabk-67-#{fSize}"
			if disabled then sButton += ' op0.3'
			else if !wait && !success then sButton += " hofo(op1) hofoc4(bgbk-1)"
			spinnerClr = 'bk-9'

	else if kind == 'circle'
		sButton += " br50% out0"
		sChildren += " xrcc"
		sBg += " br50%"

		if look == 'default'
			clr = 'gyb'
			fillClr = 'bk-8'
			spinnerClr = 'bk-6'
		else if look == 'beige'
			clr = 'beb'
			fillClr = 'bk-5'
			spinnerClr = 'bk-5'

		if wait || success then sBg += " bg#{clr}"
		if disabled then sButton += ' op0.3'

		if !wait && !success then sButton += " hofoc4(bg#{clr}) hoc5(fill#{fillClr})"


	else if kind == 'popup'
		sButton += " xg1 xb1 _fade1 xrcc fabk-57-15 borlbk-0 borrbk-0 borbbk-0 bortgyb-8 nf(borlgyb-8) l(br0_0_10_0) f(br0_0_0_10)"
		sChildren += " br4 p#{pvSize*2.4}_#{phSize}"

		if look == 'blue'
			sButton += " bgwh xg1 #{disabled && 'fabk-1' || 'hofo(fabk-6 bgbu bordbk-2) bortgyb nf(borlgyb)  out0' }"
			spinnerClr = 'buk-6'
			sSpinner += " h80%"
		else if look == 'text'
			sButton += "bgbe #{disabled && 'fabk-1' || 'f_bk-2 ho(fabk-6 bordbk-2)'}"
			spinnerClr = 'bk-3'
			sSpinner += " h80%"

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
		sSpinner += " h120% m-10%"
		sSuccess += " h120% m-10%"


		sKind = "lh110%"

		if look == 'default'
			sChildren += " fabuk-67-#{fSize} borbbuk-2 ho(fabuk borbbuk-7)"
			spinnerClr = 'buk'
		else if look == 'noLine'
			sChildren += " fabuk-67-#{fSize} ho(fabuk)"
			spinnerClr = 'buk'

	else if kind == 'custom'
		sChildren += " xrcc"



	onClickSelf = (e) ->
		if wait || disabled || success then return e.preventDefault()
		onClick? e

	onSubmit = (e) ->
		if wait then e.preventDefault()

	extra = {onClick: onClickSelf}
	if rest.type == 'submit' then extra.onSubmit = (e) -> if wait then e.preventDefault()

	if wait || success then sChildren += " op0 pen"


	# Impossible to animate from width=100 to unset/auto (https://css-tricks.com/using-css-transitions-auto-dimensions/).
	# Easiest trick is animate min-width and we're setting min-width to 20 since it's probably small enough
	# for most cases but still big enough that if the child of sBg (Spinner/Checkmark) dissapears before
	# animating out again, the animation does not start from 0 but 20 and looks less bad.
	# Alternative would be min-width: 0 and use _ 'svg', {s: 'h100%', viewBox: "0 0 1 1"} as a placeholder
	# when Spinner/Checkmark is not shown, but we don't want unnessecary elements and current way good enough
	if wait || success
		sBg += " br50% iw20"

	_ 'button', {s: "#{sButton} #{s}", className, ref, ...extra, ...rest},
		_ {s: "#{sBg} #{sBgProp}", className: "c4 xrcc spinnerBg #{success && 'spinnerScale'}"},
			if wait then _ Spinner, {s: "p2 #{sSpinner}", clr: spinnerClr}
			else if success then _ Checkmark, {s: "#{sSuccess}", clr: spinnerClr}

		_ {s: "#{sChildren} #{sChildrenProp}", className: 'c5'},
			children












