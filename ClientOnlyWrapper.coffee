 #auto_require: _esramda
import {} from "ramda-extras" #auto_require: esramda-extras
import React, {useState, useEffect} from 'react'

import {_} from 'setup'

# With next sometimes you have the need to have client only renders like with portals
# https://github.com/vercel/next.js/blob/canary/examples/with-portals/components/ClientOnlyPortal.js
# but then they don't play well with CSSTransition so seems to work to wrap things in 
# ClientOnlyWrapper on a higher level
export default ClientOnlyWrapper = ({children}) ->
	[mounted, setMounted] = useState false

	useEffect ->
		setMounted true
	, []

	return if mounted then children else null
