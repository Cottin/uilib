import React from 'react'

import {useFela, colors} from 'setup'

export Spinner = ({s, clr = 'wh'}) ->
	_ 'svg', {s: "h100% fill0 #{s}", className: 'spinnerSvg', viewBox: '0 0 24 24', xmlns: 'http://www.w3.org/2000/svg'},
		_ 'circle', {cx: '12', cy: '12', stroke: colors(clr), r: '10', strokeWidth: '3', className: "spinnerStroke"}
		_ 'circle', {cx: '21.3', cy: '16', fill: colors(clr), r: '1.48'}


export Checkmark = ({s, clr = 'wh'}) ->
	_ 'svg', {s, className: 'checkmark', viewBox: '0 0 52 52'},
		_ 'path', {className: 'checkmark__check', fill: "none", stroke: colors(clr), d: "M14.1 27.2l7.1 7.2 16.7-16.8"}



