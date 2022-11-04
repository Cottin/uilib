import React from 'react'


import {_} from 'setup'


# https://cssloaders.github.io/
export default Spinner = ({kind = 'jumpingBalls', scale = 1.0, clr = 'bk'}) ->
	_ {className: "spinner-#{kind}", style: {color: _.colors(clr), transform: "scale(#{scale})"}}

