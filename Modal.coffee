 #auto_require: _esramda
import {} from "ramda-extras" #auto_require: esramda-extras
import React, {useRef, useState, useEffect} from 'react'
import {CSSTransition} from 'react-transition-group'
import {createPortal} from 'react-dom'

import {useFela} from 'setup'

import ClientOnlyWrapper from 'uilib/ClientOnlyWrapper'


# Quite a bit of research went in to this component.
#
# - Portal above does not play well with next.js (Expected server HTML to contain a matching <div> in <div>).
#		But the suggested client only portal at https://github.com/vercel/next.js/blob/canary/examples/with-portals/components/ClientOnlyPortal.js
#		don't play well with CSSTransition. So we leave Portal simple and wrap everything with ClientOnlyWrapper.
#
# - It's possible to use a backdropFilter but blur effect is less nice than feGaussianBlur and more
#		importantly it makes the animation lag. Adding filter = blur on rootElement doesn't seem to add too much 
# 	lagg if not done as an animation.
#		If you want to try backdropFilter, replace backdrop element with this:
# 	_ {s: 'posf w100% h100% z10 xrcc top0 lef0', style: {backdropFilter: 'blur(4px)'}, className: 'backdrop'}
#	
# - If you want to see more details from research check out commit from 2022-11-04 ModalOld.coffee

# https://stackoverflow.com/a/59154364/416797
export Portal = ({children, rootSelector}) ->
	[container] = React.useState () ->
		# // This will be executed only on the initial render
		# // https://reactjs.org/docs/hooks-reference.html#lazy-initial-state
		return document.createElement 'div'

	React.useEffect () ->
		document.body.appendChild(container)
		return () -> document.body.removeChild(container)
	, []

	return createPortal children, container


# Usage 1:
# _ Modal, {open},
#		_ MyInnerModal, {}
#
# Result: MyInnerModal only rendered when open=true so little better perf and state and useCall is reset
#					between open/close of modal.
#
# Usage 2:
# _ MyModal, {open: isOpen}
#	...
# MyModal = ({open}) ->
#   _ Modal, {open},
#     _ {}, ...
#
# Result: MyModal always rendered even when open=false so little worse perf but state and useCall will never
#					reset between open/close of modal.

export default Modal = ({s, open, children, rootSelector = '#__next'}) ->
	[ready, setReady] = useState false

	useEffect () ->
		timeout = setTimeout (-> setReady true), 100 # offset so if page is refreshed with open = true, animation plays
		return () -> clearTimeout timeout
	, []


	onEntering = () ->
		document.querySelector(rootSelector).style.filter = 'blur(4px)'

	onExiting = () ->
		document.querySelector(rootSelector).style.filter = 'none'

	_ ClientOnlyWrapper, {},
		_ CSSTransition, {in: open && ready, unmountOnExit: true, timeout: 300, classNames: "aniModal", onExiting, onEntering},
			_ Portal, {rootSelector},
				_ {s: "#{s} posa w100% p0_20 z11 top15vh <500[top5vh] xrc_ xg1"},
					children
				_ {s: 'posf w100% h100% z10 bgbk-2 xrcc top0 lef0', className: 'backdrop'}

				_ 'svg', {height: 0, width: 0},
					_ 'filter', {id: "blurFilter"},
						_ 'feGaussianBlur', {stdDeviation: 4}

