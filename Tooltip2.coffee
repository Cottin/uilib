import _replace from "ramda/es/replace"; #auto_require: _esramda
import {} from "ramda-extras" #auto_require: esramda-extras

import React, {useRef, useState} from 'react'

import {useChangeState} from 'uilib/reactUtils'

import {useFela, colors} from 'setup'
import SVGtriangleSmall from 'icons/triangleSmall.svg'
import {Portal} from './Modal'

# Better tooltip using Portal so no need for z-index complexity.
# Since you wrap things with this, if disable=true only children is reutrned with minimal overhead
export default Tooltip2 = ({s, sInner, sTriangle, children, text, direction = 'up', margin = 7, disable}) ->
	ref = useRef null
	[style, setStyle] = useState 'op0 top0 lef0 pen'
	[tri, setTri] = useState ''

	if disable then return children

	onMouseEnter = (e) ->
		{top, left, width, height} = rect = ref.current?.getBoundingClientRect()
		{scrollY, scrollX} = window

		topAndScroll = top + scrollY
		leftAndScroll = left + scrollX
		
		switch direction
			when 'up'
				setStyle "op1 top#{topAndScroll - margin}px lef#{leftAndScroll + width / 2}px transX-50% transY-100%"
				setTri 'top100% rot180'
			when 'down'
				setStyle "op1 top#{topAndScroll + height + margin}px lef#{leftAndScroll + width / 2}px transX-50%"
				setTri 'bot100%'
			when 'left'
				setStyle "op1 top#{topAndScroll + height/2}px lef#{leftAndScroll - margin}px transY-50% transX-100%"
				setTri 'lef100% ml-3px rot90'
			when 'right'
				setStyle "op1 top#{topAndScroll + height/2}px lef#{leftAndScroll + width + margin}px transY-50%"
				setTri 'rig100% mr-3px rot270'


	onMouseLeave = (e) ->
		setStyle _replace(/op1/, 'op0 pen', style)

	_ {onMouseEnter, onMouseLeave, ref},	
		children
		_ Portal, {},
			_ {s: "posa z9 ease200_opacity #{style}"},
				_ {s: "bggya op0.98 br5 posr xccc tac fawh-97-14 pen #{sInner}"},
					_ SVGtriangleSmall, {s: "#{tri} posa w10 fillgya #{sTriangle}"}
					text

