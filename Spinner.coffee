import React from 'react'

import {useFela, colors} from 'setup'

# https://cssloaders.github.io/
export default Spinner = ({kind = 'jumpingBalls', scale = 1.0, clr = 'bk'}) ->
	_ {className: "spinner-#{kind}", style: {color: colors(clr), transform: "scale(#{scale})"}}

