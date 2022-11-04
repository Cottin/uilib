import filter from "ramda/es/filter"; #auto_require: esramda
import {} from "ramda-extras" #auto_require: esramda-extras
import React, {useRef, useState, useEffect} from 'react'
import {createPortal} from 'react-dom'

import {_} from 'setup'


# https://stackoverflow.com/a/59154364/416797
Portal = ({children, rootSelector}) ->
	[container] = React.useState () ->
		# // This will be executed only on the initial render
		# // https://reactjs.org/docs/hooks-reference.html#lazy-initial-state
		return document.createElement 'div'

	React.useEffect () ->
		document.body.appendChild(container)
		# document.querySelector(rootSelector).style.animation = "blur 3s"
		# document.querySelector(rootSelector).style.filter = "url('#blurFilter')"
		# document.querySelector(rootSelector).style.filter = "brightness(10%)"
		document.querySelector(rootSelector).style.filter = 'blur(4px)'
		# document.querySelector(rootSelector).style.transition = 'none'
		# document.querySelector('.backtest').style.backdropFilter = "blur(4px)"
		# document.querySelector(rootSelector).style.transition = "10ms filter ease-out"
		return () ->
			# document.querySelector(rootSelector).style.transition = '100ms filter ease-out'
			# document.querySelector(rootSelector).style.filter = 'none'
			# document.querySelector('.backtest')?.style.backdropFilter = "none"
			document.body.removeChild(container)
	, []

	return createPortal children, container


# NOTE: Portal above does not play well with next.js (Expected server HTML to contain a matching <div> in <div>).
#				But the suggested client only portal at https://github.com/vercel/next.js/blob/canary/examples/with-portals/components/ClientOnlyPortal.js
#				don't play well with CSSTransition. So make sure to wrap your CSSTransition (that wrapps Modal) in a
#				ClientOnlyWrapper.
export default Modal = ({s, children, rootSelector = '#__next'}) ->
	_ Portal, {rootSelector},
		_ {s: s + 'posa w100% p0_20 z11 top15vh <500[top5vh] xrc_ xg1 '},
			children
		# _ {s: 'posf w100% h100% z10 op0.95 bgbk-2 xrcc top0 lef0', style: {backdropFilter: 'blur(4px)'},
		# className: 'backdrop'}
		_ {s: 'posf w100% h100% z10 bgbk-2 xrcc top0 lef0', className: 'backdrop'}
		# _ {s: 'posf w100% h100% z10 bgbk-2 xrcc top0 lef0', className: 'backtest'}
		# _ {s: 'posf w100% h100% z10 bgbk-2 xrcc top0 lef0', style: {filter: "url('#blurFilter')"}}
		# _ {s: 'posf w100% h100% z10 xrcc top0 lef0', style: {backdropFilter: 'blur(4px)'}}

		_ 'svg', {height: 0, width: 0},
			_ 'filter', {id: "blurFilter"},
				_ 'feGaussianBlur', {stdDeviation: 4}


# This is suggestion from next.js which does not play well with CSSTransition
# https://github.com/vercel/next.js/blob/canary/examples/with-portals/components/ClientOnlyPortal.js
# ClientOnlyPortal = ({children, modalSelector, rootSelector}) ->
#   ref = useRef()
#   [mounted, setMounted] = useState false

#   useEffect ->
#     ref.current = document.querySelector modalSelector
#     document.querySelector(rootSelector).style.filter = "url('#blurFilter')"
#     setMounted true
#     return () -> document.querySelector(rootSelector).style.filter = 'none'
#   , [modalSelector]

#   return if mounted then createPortal children, ref.current else null


# export default Modal = ({s, children, modalSelector = '#modal', rootSelector = '#__next'}) ->
#   _ ClientOnlyPortal, {children, modalSelector, rootSelector},
#     _ {s: s + 'posa w100% p0_20 z11 top15vh <500[top5vh] xrc_ xg1 '},
#       children
#     _ {s: 'posf w100% h100% z10 bgbk-1 xrcc _fade1 top0 lef0'}

#     _ 'svg', {height: 0, width: 0},
#       _ 'filter', {id: "blurFilter"},
#         _ 'feGaussianBlur', {stdDeviation: 5}
