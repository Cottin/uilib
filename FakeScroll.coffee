 #auto_require: _esramda
import {} from "ramda-extras" #auto_require: esramda-extras
import React, {useState, useEffect, useRef, useDeferredValue} from 'react'
import {useMouseMonitor} from './reactUtils'

import {useFela, colors} from 'setup'

###
Scroll bars could be overlayed (as on macbooks when no mouse and no screen is connected) or be a fixed bar
(as on macbooks with a mouse or a screen connected).

If a scroll bar is not overlayed (eg. a mac with a mouse connected), the layout will shift if content goes
from small to too big to fit in the window. Eg. when opening a popup that's long would cause layout shifts
and a janky UI.

Also a non-overlayed scroll bar takes up space on the screen which needs to be accounted for. Eg. if you have
a wrapped layout where items have width: 25%, they will no longer fit 4 per row when scrollbar is present.

To account for a scroll bar that can be overlayed or not based on users hardware is a pain.
One way of handling this is to force an overlayed scroll bar and style it yourself like so:

	body { overflow: overlay; }
	*::-webkit-scrollbar { display: block; width: 16px; } ...
	# eg. https://dev.to/jonosellier/easy-overlay-scrollbars-variable-width-1mbh

This is a trick that eg. Toggl uses.
The trick only works for webkit so you need a fallback to worse option in Firefox.

As of Chromium 114 (June 2023) overlay scrollbar functionality has been removed from webkit too.
More discussion is done here: https://stackoverflow.com/questions/23200639/transparent-scrollbar-with-css

An alternative is to either always force scroll bars to be added to the right by overflow-y: scroll but that
makes the UI less attractive and we have to account for the width of the scroll bar.

(Note: now, at 28 june 2023, I cannot get the native overlayed scroll bars to show on my macbook without a
mouse connected. Is this a thing of the past?)

A second alternative is to use the scrollbar-gutter to say scrollbar-gutter: stable both-edges; but that only
reserves space on the right side and pushes your normal content to the left so unless you have a very simple
design with only one uniform background color and no heading, there will be a thick border on the right side
what looks different from the rest of the page because that's the reserved space for the scroll bar that migth
show up there.
https://css-tricks.com/almanac/properties/s/scrollbar-gutter/

As stated in the stack overflow article
https://stackoverflow.com/questions/23200639/transparent-scrollbar-with-css
there is as of June 2023 not a native way of having overlayed scroll bars.

If you're making a website for grand parents, you should probably just always have a native scroll bar.
But there are plenty of web applications that's targeted twoards a savvy audience that cares about the design
and as a developer you could want to force a more sleek overlayed scroll bar functionallity.

You could give up on native scroll bars and use a library like https://kingsora.github.io/OverlayScrollbars/
which it seems Spotify have done.
I tested it but on a refresh, the lib takes a while to load and then scroll seemed not correct. Another
question is how this behaves with navigation and scroll restoration. It feels like an over-engineered solution
that's not really worth it to me. Maybe it could be configured correctly but I was too lazy?



FakeScroll is an attempt to achive overlayed scrollbars without messing to much with native scrolling.
If just hides the native scrollbar by setting its width to 0px and renders a position: fixed fake scroll bar
that looks modern and "decent" without going crazy lengths to making it look native.

Known issues:
	- Only working for window/body now, not in specific overflowed elements
	- Not taking into account if content is added later (but as soon as you scroll will recalculate)


Basically: use as an experiment and see if it's good enough for my apps.
###


	
export staticStyles = "
	body::-webkit-scrollbar {
		display: none; /* Chrome */
	}

	html {
		scrollbar-width: none; /* Firefox */
	}

	@media print {
		.hide-print {
			display: none !important;
		}
	}
"

calcHeightAndHide = () ->
	heightPercent = window.innerHeight / window.document.body.scrollHeight
	height = heightPercent * window.innerHeight

	hide = window.document.body.scrollHeight == window.innerHeight

	return {height, hide}

calcScrollBar = () ->
	{height, hide} = calcHeightAndHide()

	scrollPercent = window.pageYOffset / (window.document.body.scrollHeight - window.innerHeight)
	top = scrollPercent * (window.innerHeight - height)

	return {height, top, hide}


export default FakeScroll = ({sOut = 'bgbk-2', sOver = 'bgbk-5'}) ->
	[{top, height, hide}, setScroll] = useState {top: 0, height: 0, hide: true}
	refDrag = useRef null
	[forceUpdateCount, setForceUpdateCount] = useState 0
	forceUpdate = () -> setForceUpdateCount (x) -> x + 1

	useEffect () ->
		onScroll = () -> setScroll calcScrollBar()

		setScroll calcScrollBar()

		window.removeEventListener 'scroll', onScroll
		window.addEventListener 'scroll', onScroll, { passive: true }
		window.removeEventListener 'resize', onScroll
		window.addEventListener 'resize', onScroll, { passive: true }

		sizeCheck = () -> 
			# Can't find an event for when scrollHeight changes so polling as a workaround
			check = calcHeightAndHide()
			if check.height != height || check.hide != hide
				setScroll (current) -> {...current, height: check.height, hide: check.hide}

		timeout = window.setTimeout sizeCheck, 100 # one extra at 100 for nicer initial load
		interval = window.setInterval sizeCheck, 1000

		return () ->
			window.removeEventListener 'scroll', onScroll
			window.removeEventListener 'resize', onScroll
			window.clearTimeout timeout
			window.clearInterval interval
	, []

	onMouseDown = (e) -> 
		refDrag.current = {lastY: e.screenY}

	mouseUp = () -> 
		refDrag.current = null
		forceUpdate()

	mouseMove = (e) ->
		if !refDrag.current then return 

		dy = e.screenY - refDrag.current.lastY
		refDrag.current.lastY = e.screenY

		dyScaled = dy / window.innerHeight * window.document.body.scrollHeight

		window.scrollBy 0, dyScaled

	useMouseMonitor {mouseMove, mouseUp}, [], () ->
		refDrag.current = null


	sDrag = if refDrag.current then 'rig0' else 'rig-5'
	sHide = if hide then 'disn'
	_ {s: "ho(rig0) hoc1(#{sOver}) #{sDrag} useln w20 h#{height}px posf top#{top}px z9999 xre_ #{sHide}"
	style: {transition: 'right 0.08s ease-out 0s'}, className: 'hide-print',
	onMouseDown},
		_ {s: "w50% #{sOut} h100% _fade1 #{refDrag.current && sOver}", className: 'c1'}
