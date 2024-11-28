import _always from "ramda/es/always"; import _equals from "ramda/es/equals"; import _flip from "ramda/es/flip"; import _isNil from "ramda/es/isNil"; import _map from "ramda/es/map"; import _type from "ramda/es/type"; import _without from "ramda/es/without"; #auto_require: _esramda
import {change, diff, isNilOrEmpty, sf2} from "ramda-extras" #auto_require: esramda-extras

import React, {useState, useEffect, useRef, useCallback} from 'react'

import {_} from 'setup'


export memoDeep = (f) -> React.memo f, _equals


comparatorWithLog = (prevProps, nextProps) ->
	isSame = _equals prevProps, nextProps
	# Note: diff does not support functions so any onClick will break this
	if !isSame then console.log 'isSame', isSame, 'diff', diff prevProps, nextProps
	return isSame

memoDeep.debug = (f) -> React.memo f, comparatorWithLog

export isMountedGuard = (isMountedRef) ->
	# https://daviseford.com/blog/2019/07/11/react-hooks-check-if-mounted.html
	React.useEffect () ->
		isMountedRef.current = true
		return () -> isMountedRef.current = false
	, []

export useChangeState = (initial) ->
	[state, setState] = React.useState initial
	changeState = (spec) -> setState change spec
	resetState = -> setState initial
	return [state, changeState, resetState]

# Sometimes things changes too quickly and your component wants to render the previous application state.
# Eg. a modal where you mark hours as invoiced/uninvoiced wants to keep showing the previous state even
# 		after the marking has been made to the data and the application state is updated.
# This hook allows you to only work with the first non-nil state that you pass to it
export useOnceState = (state) ->
	[onceState, setOnceState] = useState state

	useEffect () ->
		if _isNil onceState then setOnceState state
	, [JSON.stringify state]

	return onceState

# Stores let value passed last time
# https://blog.logrocket.com/accessing-previous-props-state-react-hooks/
export usePreviousValue = (value) ->
	ref = useRef()
	useEffect ->
		ref.current = value
		return undefined
	return ref.current

# Window callbacks (eg. mouseMove, mouseUp) closes over state so you'll get stale values in the callback.
# The workaround here is to duplicate the state to a ref that can be used as expected in a window callback.
# Another solution could be to add dependencies to the useEffect that registers the window listeners but if
# those dependencies are updating a lot we might not want the useEffect to re-register many times over.
# Discussion: https://stackoverflow.com/a/55156813/416797
#							https://reactjs.org/docs/hooks-faq.html#what-can-i-do-if-my-effect-dependencies-change-too-often
export useChangeStateRef = (initial) ->
	[state, setState_] = React.useState initial
	ref = React.useRef initial

	changeBoth = useCallback (spec) ->
		setState_ change spec
		ref.current = change spec, ref.current
		return undefined
	, []

	resetBoth = useCallback () ->
		setState_ initial
		ref.current = initial
		return undefined
	, []
	
	return [state, ref, changeBoth, resetBoth]

# Same as above but simple state
export useStateRef = (initial) ->
	[state, setState_] = React.useState initial
	ref = React.useRef initial
	changeBoth = (value) ->
		setState_ value
		ref.current = value
	resetBoth = ->
		setState_ initial
		ref.current = initial
	return [state, ref, changeBoth, resetBoth]


# # Workaround not to get stale state in window callbacks (mouseMove, mouseUp, ResizeObserver).
# # eg.
# # popup = useState {open: false, top: 120}
# # popupStaleWorkaround =
# export useStaleWorkaround = (state) ->
# 	stateRef = useRef state

# 	useEffect ->
# 		stateRef.current = state
# 		return undefined
# 	, [state]

# 	return stateRef

# Assumes ref is absolutely positioned relative to a parent and returns the nessecary adjustments needed
# to contain the ref within the viewport in shortstyle format.
# eg. if the ref is outside the viewport to the right, returned might be rig-54
# NOTE: only supporting left and right for now, add top and bottom when needed
export useContainRelativeToParent = (ref) ->
	[s, cs] = useChangeState {left: null, right: null}

	handleResize = ->
		viewportOffset = elementViewportOffset ref.current
		parentViewportOffset = elementViewportOffset ref.current?.offsetParent
		if viewportOffset.right < 0
			cs {left: 'auto', right: -1 * parentViewportOffset.right}
		if viewportOffset.left < 0
			cs {right: 'auto', left: -1 * parentViewportOffset.left}

	React.useEffect ->
		handleResize()
		window.addEventListener 'resize', handleResize
		return () -> window.removeEventListener 'resize', handleResize
	, [ref.current]

	return toShortstyleTest s

# convenient if you want to write short one-line useEffects and more beautiful than _flip(React.useEffect) ..
export useEffectFlipped = _flip React.useEffect

export useFocus = (deps) ->
	# NOTE!!!!!!! Doesn't really seem to work. Else part is needed but it throws error when component is removed
	#             Use autoFocus: true instead and go back to this when that is not enough anymore
	ref = React.useRef()
	React.useEffect ->
		if ref?.current then ref.current?.focus()
		# else
		#   _flip(setTimeout) 10, ->
		#     ref?.current?.focus() # give time if conditonal render
	, deps
	return ref

export useForceScrollbar = () ->
	React.useEffect ->
		document.body.style.overflowY = 'scroll'
		return () -> document.body.style.overflowY = 'initial'
	, []
	return null


# It is a bit overkill to create a custom event manager but the problem with global event listeners added with
# document.addEventListener is that they don't follow the bubbling order of nodes in the DOM where a child can call
# e.stopPropagation to stop the bubbling to parents. Instead listeners are called in the order they were added with
# document.addEventListener which typically means callback of parents are called before childrens callbacks.
# In order to preserve the possibility to stop bubbling, useOuterClick allows you to specify callback order using prio.
EventPrio = do ->
	handlers = {}
	globalListeners = {}

	return
		add: (event, prio, callback) ->
			handlers[event] ?= []
			eventHandlers = handlers[event]

			if !globalListeners[event]
				listener = (e) ->
					originalStopPropagation = e.stopPropagation.bind(e)
					shouldStopPropagation = false

					e.stopPropagation = () ->
						shouldStopPropagation = true
						originalStopPropagation()

					for handler in eventHandlers
						handler.callback e
						if shouldStopPropagation then break

				document.addEventListener event, listener, {capture: true}
				globalListeners[event] = listener

			if eventHandlers.length == 0
				eventHandlers.push {prio, callback}
			else
				for handler, i in eventHandlers
					if handler.prio > prio
						eventHandlers.splice i, 0, {prio, callback}
						return

				eventHandlers.push {prio, callback}


		remove: (event, callback) ->
			eventHandlers = handlers[event] || []
			for handler, i in eventHandlers
				if handler.callback == callback
					eventHandlers.splice i, 1
					if eventHandlers.length == 0
						document.removeEventListener event, globalListeners[event], {capture: true}
						delete globalListeners[event]
					break



# If you want e.preventDefault() to prevent links from being clicked capture needs to be true, that's why we force it.
# Also seems to be required if we are also removing the element that's being clicked eg. a toggle.
# https://github.com/facebook/react/issues/20325#issuecomment-732707240
export useOuterClick = (ref, onOuterClick, {prio} = {prio: null}) ->
	React.useEffect ->
		handleClick = (e) ->
			if ref.current && !ref.current.contains(e.target)
				onOuterClick(e)
		
		if ref.current
			if _isNil prio then document.addEventListener 'click', handleClick, {capture: true}
			else EventPrio.add 'click', prio, handleClick
		
		return () ->
			if _isNil prio then document.removeEventListener 'click', handleClick, {capture: true}
			else EventPrio.remove 'click', handleClick
	, [ref, onOuterClick]

export useOuterMouseDown = (ref, onOuterMouseDown, {prio} = {prio: 1}) ->
	React.useEffect ->
		handleClick = (e) ->
			if ref.current && !ref.current.contains(e.target)
				onOuterMouseDown(e)
		if ref.current
			if _isNil prio then document.addEventListener 'mousedown', handleClick, {capture: true}
			else EventPrio.add 'mousedown', prio, handleClick

		return () ->
			if _isNil prio then document.removeEventListener 'mousedown', handleClick, {capture: true}
			else EventPrio.remove 'mousedown', handleClick

	, [ref, onOuterMouseDown]

export useMouseMonitor = ({mouseMove, mouseUp}, deps, init, skip=false) ->
	React.useEffect () ->
		if skip then return () ->
		if mouseMove then window.addEventListener 'mousemove', mouseMove, {passive: true} # testing passive
		if mouseUp then window.addEventListener 'mouseup', mouseUp, {passive: true} # ...for perf improvements
		init?()
		return () ->
			if mouseMove then window.removeEventListener 'mousemove', mouseMove
			if mouseUp then window.removeEventListener 'mouseup', mouseUp
	, deps

export useKeyDownListener = (onKeyDown) ->
	useEffect () ->
		handleKeydown = (e) -> onKeyDown e
		document.addEventListener 'keydown', handleKeydown
		return () -> document.removeEventListener 'keydown', handleKeydown
	, [onKeyDown]

# Returns size of supplied ref like {width: 344, height: 102} and updates on window resize
export useMySize = (ref) ->
	[size, setSize] = React.useState {width: 0, height: 0}

	handleResize = ->
		width = ref.current?.offsetWidth || 0
		height = ref.current?.offsetHeight || 0
		setSize {width, height}

	React.useEffect ->
		handleResize()
		window.addEventListener 'resize', handleResize
		return () -> window.removeEventListener 'resize', handleResize
	, [ref.current]

	return size

# Returns size of window like {width: 344, height: 102} and updates on window resize
export useWindowSize = () ->
	[size, setSize] = React.useState {width: window?.innerWidth || 0, height: window?.innerHeight || 0}

	handleResize = ->
		width = window.innerWidth
		height = window.innerHeight
		setSize {width, height}

	React.useEffect ->
		handleResize()
		window.addEventListener 'resize', handleResize
		return () -> window.removeEventListener 'resize', handleResize
	, []

	return size
	
# Calls callback if ref is scrolled into view or close enough based on thresholdDistance.
# Note that if page is loaded with view scrolled below ref, it will call callback immediately.
# https://chat.openai.com/share/4a0b1bb1-dc2e-43c0-acd5-6d92e5ea3dd2
export useDistanceFromView = (ref, callback, thresholdDistance = 0, sendPixels = false) ->
	[hasBeenCalled, setHasBeenCalled] = useState(false)

	useEffect () ->
		calculateDistanceAndCheckView = () ->
			if hasBeenCalled then return

			if ref.current
				rect = ref.current.getBoundingClientRect()
				isVisibleOrClose = (rect.bottom - window.innerHeight <= thresholdDistance) && (rect.top < window.innerHeight)
				
				if isVisibleOrClose
					callback rect.bottom - window.innerHeight 
					setHasBeenCalled(true)
				else if sendPixels && rect.top < window.innerHeight
					callback rect.bottom - window.innerHeight 

		window.addEventListener 'scroll', calculateDistanceAndCheckView
		calculateDistanceAndCheckView()

		return () -> window.removeEventListener('scroll', calculateDistanceAndCheckView)
	, [ref, callback, hasBeenCalled, thresholdDistance]

	return undefined


# https://stackoverflow.com/a/53180013
export useDidUpdateEffect = (fn, deps) ->
	ref = React.useRef false

	React.useEffect () ->
		if ref.current then fn() else ref.current = true
		return () -> #noop
	, deps


_useCall = ({successDelay = 1500, onError = null, asyncCall}) ->
	[st, cs] = useChangeState {}
	isMounted = useRef false
	isMountedGuard isMounted

	callFn = (args...) ->
		cs {wait: true, error: undefined, result: undefined, success: undefined}
		try
			result = await Promise.resolve asyncCall args...
			if result == 'ABORT'
				cs {wait: false}
				return result
			cs {wait: false, success: true, result}
			if successDelay > 0
				setTimeout ->
					if isMounted.current != true then return
					cs {success: undefined}
				, successDelay

			return result
		catch error
			onError?(error)
			cs _always {error, wait: false}
			console.error error

	return 
		wait: st.wait
		result: st.result
		error: st.error?.meta
		fullError: st.error
		errorMessage: if !isNilOrEmpty(st.error?.message) && st.error?.message != 'null' then st.error?.message else undefined
		success: st.success
		reset: (key = undefined) ->
			# seems to either reset given key or full state but not really, TODO: test and redocument
			if key && _type(key) == 'string' && !st.error?.meta?[key] then return
			cs _always {}
		resetError: (key = undefined) ->
			if !st.error then return
			if key
				if !st.error.meta then return
				cs {error: {meta: {[key]: undefined}}}
			else cs {error: undefined}
		call: callFn

# Lets you call an async function with the abibility to throw and handle results as state
# eg. useCall -> ... or useCall {successDelay: 2000}, -> ...
export useCall = (optionsOrCall, callOrUndefined) ->
	asyncCall = if callOrUndefined then callOrUndefined else optionsOrCall
	options = if callOrUndefined then optionsOrCall else {}

	_useCall {...options, asyncCall}

export useCall2 = useCall

# Let's you define a local view model operating on local state with local operations.
# eg. Have a local normalized state:
#				{Client: {1: {id: 1, name: ..}}, Project: {2: {id: 2, name: .., clientId: 1}}}
# 		and a view model building easy to use data for the views/components:
#				(state) -> $ state.Clients, values, _map(addChildProjectsIfNeeded)
# 		and some custom operations on the normalized state:
#				changeClientName: (id, name) -> {Client: {[id]: {name}}}
# 
# Kind of like the app2 idea but local. Good if you need a view model in a file but don't need it to operate
# on shared app data, then use the architecture of app2.
export createViewModel = (makeDefaultState, customExec = {}, viewModel) ->
	initialState = makeDefaultState()
	ref = {state: initialState, vm: viewModel(initialState), subs: [], delta: {}}

	callSubs = () ->
		for sub in ref.subs
			sub {state: ref.state, vm: ref.vm}

	makeChange = (spec) ->
		ref.state = change.meta spec, ref.state, {}, ref.delta
		ref.vm = viewModel ref.state
		callSubs()

	getDelta = () -> ref.delta

	buildCustomOps = (f) ->
		return (...args) ->
			spec = f args..., ref
			makeChange spec

	exec = {change: makeChange, ...(_map(buildCustomOps, customExec))}

	subscribe = (cb) ->
		ref.subs.push cb
		return () -> ref.subs = _without cb, ref.subs

	useViewModel = (stateToVM) ->
		[localState, setLocalState] = useState () ->
			if stateToVM then reset stateToVM # we only do this first time
			return {state: ref.state, vm: ref.vm}
			
		useEffect () -> 
			cb = ({state, vm}) -> setLocalState {state, vm}
			subscribe cb
		, []

		return [localState.vm, localState.state]

	reset = (specificState = null) ->
		ref.state = if specificState then specificState else makeDefaultState()
		ref.vm = viewModel ref.state
		ref.delta = {}
		callSubs()

	Debug = () ->
		[vm, state] = useViewModel()

		_ {s: 'xr__ w100%'},
			_ 'pre', {s: 'w50%'}, sf2 vm
			_ 'pre', {s: 'w50%'}, sf2 state

	return {useViewModel, exec, reset, Debug, getDelta}

