import React from 'react'


import {useFela, colors} from 'setup'
import SVGtriangleSmall from 'icons/triangleSmall.svg'

export default Tooltip = ({s, sInner, sTriangle, children, direction = 'up', className, ...rest}) ->
	if direction == 'up'
		sDir = 'bot100% lef50% mb5'
		transform = 'translateX(-50%)'
		sTri = 'top100% rot180'

	else if direction == 'down'
		sDir = 'top100% lef50% mt5'
		transform = 'translateX(-50%)'
		sTri = 'bot100%'

	else if direction == 'left'
		sDir = 'rig100% top50% mr5'
		transform = 'translateY(-50%)'
		sTri = 'lef100% ml-3px rot90'

	else if direction == 'right'
		sDir = 'lef100% top50% ml5'
		transform = 'translateY(-50%)'
		sTri = 'rig100% mr-3px rot270'


	_ {s: "#{sDir} posa op0 z9999999 pen #{s}", style: {transform}, className: "tooltip-panel #{className}",
	...rest},
		_ {s: "bggya op0.98 br5 posr xccc tac fawh-97-14 #{sInner}"},
			_ SVGtriangleSmall, {s: "#{sTri} posa w10 fillgya #{sTriangle}"}
			children

