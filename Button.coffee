import React from 'react'


import {_} from 'setup'

Hello = ({name}) ->
	[count, setCount] = React.useState 1
	# capitals = 'This Is A: String'.match(/[A-Z:]/g)
	# test = {:a, b: {b1: null, :b2, b3: 'this is :just a strin'}, :c, :test2}
	_ 'div', {},
		_ 'div', {}, "Bonjour #{name} for the #{count} th time11"
		_ 'button', {onClick: () -> setCount(count + 1)}, "+"

export default Home = () ->
	_ 'div', {},
		_ Hello, {name: 'Victor12345'}

