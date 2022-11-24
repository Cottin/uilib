import always from "ramda/es/always"; import equals from "ramda/es/equals"; import flip from "ramda/es/flip"; import init from "ramda/es/init"; import map from "ramda/es/map"; import type from "ramda/es/type"; import without from "ramda/es/without"; #auto_require: esramda
import {change, diff, isNilOrEmpty, sf2} from "ramda-extras" #auto_require: esramda-extras

import React, {useState, useEffect} from 'react'

import {_} from 'setup'


export memoDeep = (f) -> React.memo f, equals

comparatorWithLog = (prevProps, nextProps) ->
	isSame = equals prevProps, nextProps
	# Note: diff does not support functions so any onClick will break this
	if !isSame then console.log 'isSame', isSame, 'diff', diff prevProps, nextProps
	return isSame

memoDeep.debug = (f) -> React.memo f, comparatorWithLog

export isMountedGuard = (isMountedRef) ->
	# https://daviseford.com/blog/2019/07/11/react-hooks-check-if-mounted.html
	React.useEffect (() -> () -> return isMountedRef.current = false), []

export useChangeState = (initial) ->
	[state, setState] = React.useState initial
	changeState = (spec) -> setState change spec
	resetState = -> setState initial
	return [state, changeState, resetState]

# Window callbacks (eg. mouseMove, mouseUp) closes over state so you'll get stale values in the callback.
# The workaround here is to duplicate the state to a ref that can be used as expected in a window callback.
# Another solution could be to add dependencies to the useEffect that registers the window listeners but if
# those dependencies are updating a lot we might not want the useEffect to re-register many times over.
# Discussion: https://stackoverflow.com/a/55156813/416797
#							https://reactjs.org/docs/hooks-faq.html#what-can-i-do-if-my-effect-dependencies-change-too-often
export useChangeStateRef = (initial) ->
	[state, setState_] = React.useState initial
	ref = React.useRef initial
	changeBoth = (spec) ->
		setState_ change spec
		ref.current = change spec, ref.current
	resetBoth = ->
		setState_ initial
		ref.current = initial
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

# convenient if you want to write short one-line useEffects and more beautiful than flip(React.useEffect) ..
export useEffectFlipped = flip React.useEffect

export useFocus = (deps) ->
	# NOTE!!!!!!! Doesn't really seem to work. Else part is needed but it throws error when component is removed
	#             Use autoFocus: true instead and go back to this when that is not enough anymore
	ref = React.useRef()
	React.useEffect ->
		if ref?.current then ref.current?.focus()
		# else
		#   flip(setTimeout) 10, ->
		#     ref?.current?.focus() # give time if conditonal render
	, deps
	return ref

export useForceScrollbar = () ->
	React.useEffect ->
		document.body.style.overflowY = 'scroll'
		return () -> document.body.style.overflowY = 'initial'
	, []
	return null

export useOuterClick = (ref, onOuterClick) ->
	React.useEffect ->
		handleClick = (e) -> if ref.current && !ref.current.contains(e.target) then onOuterClick()
		# {capture: true} important if we are also removing the element that's being clicked eg. a toggle.
		# https://github.com/facebook/react/issues/20325#issuecomment-732707240
		if ref.current then document.addEventListener 'click', handleClick, {capture: true}
		return () -> document.removeEventListener 'click', handleClick, {capture: true}
	, [ref, onOuterClick]

export useOuterMouseDown = (ref, onOuterMouseDown) ->
	React.useEffect ->
		handleClick = (e) -> if ref.current && !ref.current.contains(e.target) then onOuterMouseDown(e)
		# {capture: true} important if we are also removing the element that's being clicked eg. a toggle.
		# https://github.com/facebook/react/issues/20325#issuecomment-732707240
		if ref.current then document.addEventListener 'mousedown', handleClick, {capture: true}
		return () -> document.removeEventListener 'mousedown', handleClick, {capture: true}
	, [ref, onOuterMouseDown]

export useMouseMonitor = ({mouseMove, mouseUp}, deps, init, skip=false) ->
	React.useEffect () ->
		if skip then return () ->
		if mouseMove then window.addEventListener 'mousemove', mouseMove
		if mouseUp then window.addEventListener 'mouseup', mouseUp
		init?()
		return () ->
			if mouseMove then window.removeEventListener 'mousemove', mouseMove
			if mouseUp then window.removeEventListener 'mouseup', mouseUp
	, deps

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
	[size, setSize] = React.useState {width: 0, height: 0}

	handleResize = ->
		width = window.innerWidth
		height = window.innerWidth
		setSize {width, height}

	React.useEffect ->
		handleResize()
		window.addEventListener 'resize', handleResize
		return () -> window.removeEventListener 'resize', handleResize
	, []

	return size

# https://stackoverflow.com/a/53180013
export useDidUpdateEffect = (fn, deps) ->
	ref = React.useRef false

	React.useEffect () ->
		if ref.current then fn() else ref.current = true
		return () -> #noop
	, deps


_useCall = ({successDelay = 1500, onError = null, asyncCall}) ->
	isMounted = React.useRef true
	isMountedGuard isMounted

	[st, cs] = useChangeState {}

	callFn = (args...) ->
		cs {wait: true, error: undefined, result: undefined}
		try
			result = await Promise.resolve asyncCall args...
			if result == 'ABORT'
				cs {wait: false}
				return result
			if !isMounted.current then return result

			cs {wait: false, success: true, result}
			if successDelay > 0 then setTimeout (->
				if !isMounted.current then return result
				cs {success: undefined}), successDelay

			return result
		catch error
			onError?(error)
			cs always {error, wait: false}
			console.error error

	return 
		wait: st.wait
		result: st.result
		error: st.error
		success: st.success
		reset: (key = undefined) ->
			# seems to either reset given key or full state but not really, TODO: test and redocument
			if key && type(key) == 'string' && !st.error?.meta?[key] then return
			cs always {}
		call: callFn

# Lets you call an async function with the abibility to throw and handle results as state
# eg. useCall -> ... or useCall {successDelay: 2000}, -> ...
export useCall = (optionsOrCall, callOrUndefined) ->
	asyncCall = if callOrUndefined then callOrUndefined else optionsOrCall
	options = if callOrUndefined then optionsOrCall else {}

	_useCall {...options, asyncCall}


_useCall2 = ({successDelay = 1500, onError = null, asyncCall}) ->
	isMounted = React.useRef true
	isMountedGuard isMounted

	[st, cs] = useChangeState {}

	callFn = (args...) ->
		cs {wait: true, error: undefined, result: undefined}
		try
			result = await Promise.resolve asyncCall args...
			if result == 'ABORT'
				cs {wait: false}
				return result
			if !isMounted.current then return result

			cs {wait: false, success: true, result}
			if successDelay > 0 then setTimeout (->
				if !isMounted.current then return result
				cs {success: undefined}), successDelay

			return result
		catch error
			onError?(error)
			cs always {error, wait: false}
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
			if key && type(key) == 'string' && !st.error?.meta?[key] then return
			cs always {}
		resetError: (key = undefined) ->
			if !st.error then return
			if key
				if !st.error.meta then return
				cs {error: {meta: {[key]: undefined}}}
			else cs {error: undefined}
		call: callFn

# Lets you call an async function with the abibility to throw and handle results as state
# eg. useCall -> ... or useCall {successDelay: 2000}, -> ...
export useCall2 = (optionsOrCall, callOrUndefined) ->
	asyncCall = if callOrUndefined then callOrUndefined else optionsOrCall
	options = if callOrUndefined then optionsOrCall else {}

	_useCall2 {...options, asyncCall}



# Let's you define a local view model operating on local state with local operations.
# eg. Have a local normalized state:
#				{Client: {1: {id: 1, name: ..}}, Project: {2: {id: 2, name: .., clientId: 1}}}
# 		and a view model building easy to use data for the views/components:
#				(state) -> $ state.Clients, values, map(addChildProjectsIfNeeded)
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

	exec = {change: makeChange, ...(map(buildCustomOps, customExec))}

	subscribe = (cb) ->
		ref.subs.push cb
		return () -> ref.subs = without cb, ref.subs

	useViewModel = (initialState) ->
		[localState, setLocalState] = useState () ->
			if initialState then reset initialState # we only do this first time
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

