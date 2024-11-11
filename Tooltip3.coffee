 #auto_require: _esramda
import {} from "ramda-extras" #auto_require: esramda-extras

import React, {useRef, useState} from 'react'
import {CSSTransition} from 'react-transition-group'

import {useFela} from 'setup'
import SVGtriangleSmall from 'icons/triangleSmall.svg'
import {Portal2} from './Modal'


# Improved tooltip that only renders when needed for better performance
export default Tooltip3 = ({s, sInner, sTriangle, children, text, direction = 'up', margin = 7, disable}) ->
	ref = useRef null
	[style, setStyle] = useState 'top0 lef0 pen'
	[show, setShow] = useState false
	[tri, setTri] = useState ''

	if disable then return children

	onMouseEnter = (e) ->
		{top, left, width, height} = rect = ref.current?.getBoundingClientRect()
		{scrollY, scrollX} = window

		topAndScroll = top + scrollY
		leftAndScroll = left + scrollX
		
		setShow true
		switch direction
			when 'up'
				setStyle "top#{topAndScroll - margin}px lef#{leftAndScroll + width / 2}px transX-50% transY-100%"
				setTri 'top100% rot180'
			when 'down'
				setStyle "top#{topAndScroll + height + margin}px lef#{leftAndScroll + width / 2}px transX-50%"
				setTri 'bot100%'
			when 'left'
				setStyle "top#{topAndScroll + height/2}px lef#{leftAndScroll - margin}px transY-50% transX-100%"
				setTri 'lef100% ml-3px rot90'
			when 'right'
				setStyle "top#{topAndScroll + height/2}px lef#{leftAndScroll + width + margin}px transY-50%"
				setTri 'rig100% mr-3px rot270'


	onMouseLeave = (e) ->
		setShow false

	_ {s, onMouseEnter, onMouseLeave, ref},	
		children
		_ CSSTransition, {in: show, unmountOnExit: true, timeout: 300, classNames: "aniTooltip", appear: true},
			_ Portal2, {},
				_ {s: "posa z100 pen #{style}"},
					_ {s: "bggya op0.98 br5 posr xccc tac fawh-97-14 pen #{sInner}"},
						_ SVGtriangleSmall, {s: "#{tri} posa w10 fillgya #{sTriangle}"}
						text


