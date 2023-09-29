import React from 'react'

import SVGgoogle from 'icons/google.svg'
import {useCall2} from 'uilib/reactUtils'
import {sleep} from 'comon/shared'

import Button from './Button2'
import LinkButton from './LinkButton2'
import Spinner from './Spinner2'
import Tooltip from './Tooltip'

import {useFela, colors} from 'setup'

export default Demo = () ->
	_ {},
		# _ {}, 'test123'
		_ ButtonDemo, {}
		_ LinkButtonDemo, {}
		_ TooltipDemo, {}
		_ SpinnerDemo, {}


Box = ({title, children}) -> 
	_ {s: 'bgwh bordbk-1 p30_10_10_10 m20 posr'},
		_ {s: 'posa top-10 bgbk bordbk-1 p2_10 br3 fawh-97-14'}, title
		children

Box1 = ({title, children}) -> 
	_ {s: 'borlbk-1 p30_10_10_10 m20 posr'},
		_ {s: 'posa top-10 lef-5 bgbk>5 bordbk-1 p2_10 br3 fawh-97-14'}, title
		children

Item = ({desc, children}) ->
	_ {s: 'mb20'},
		children
		if desc then _ {s: 'fabk-36-12'}, desc




ButtonDemo = () ->
	fake = useCall2 ->
		await sleep 2000

	onClick = fake.call
	wait = fake.wait
	success = fake.success

	_ Box, {title: 'Button'},

		_ Box1, {title: 'Kind = rounded'},

			_ Item, {desc: 'look: default'},
				_ {s: 'xr__'},
					_ {s: 'mr10 h80'},
						_ Button, {s: 'mb20', kind: 'rounded', scale: 1.2, onClick, wait, success}, 'Scale 1.2'
					_ {s: 'mr10 h80'},
						_ Button, {s: 'mb20', kind: 'rounded', onClick, wait, success}, 'Save'
					_ {s: 'mr10 h80'},
						_ Button, {s: 'mb20', kind: 'rounded', onClick, wait, disabled: true, success}, 'Save'
					_ {s: 'mr10 h80'},
						_ Button, {s: 'mb20', kind: 'rounded', scale: 0.6, onClick, wait, success}, 'Scale 0.6'
					_ {s: 'mr10 h80'},
						_ Button, {s: 'mb20', kind: 'rounded', scale: 0.7, onClick, wait, success}, 'Scale 0.7'
					_ {s: 'mr10 h80'},
						_ Button, {s: 'mb20', kind: 'rounded', scale: 0.8, onClick, wait, success}, 'Scale 0.8'
					_ {s: 'mr10 h80'},
						_ Button, {s: 'mb20', kind: 'rounded', scale: 0.9, onClick, wait, success}, 'Scale 0.9'
					_ {s: 'mr10 h80'},
						_ Button, {s: 'mb20', kind: 'rounded', scale: 1.1, onClick, wait, success}, 'Scale 1.1'

			_ Item, {desc: 'look: default, color: sea, coral'},
				_ {s: 'xr__'},
					_ {s: 'mr10'},
						_ Button, {s: 'mb20', kind: 'rounded', color: 'sea', onClick, wait, success}, 'Save'
					_ {s: 'mr10'},
						_ Button, {s: 'mb20', kind: 'rounded', color: 'sea', onClick, wait, success, disabled: true}, 'Save'
					_ {s: 'mr10'},
						_ Button, {s: 'mb20', kind: 'rounded', color: 'coral', onClick, wait, success}, 'Save'
					_ {s: 'mr10'},
						_ Button, {s: 'mb20', kind: 'rounded', color: 'coral', onClick, wait, success, disabled: true}, 'Save'

			_ Item, {desc: 'look: text'},
				_ {s: 'xr__'},
					_ {s: 'mr10'},
						_ Button, {s: 'mb20', kind: 'rounded', look: 'text', onClick, wait, success}, 'Cancel'
					_ {s: 'mr10'},
						_ Button, {s: 'mb20', kind: 'rounded', look: 'text', onClick, wait, success, disabled: true}, 'Cancel'

		_ Box1, {title: 'Kind = login'},

			_ Item, {desc: 'look: default'},
				_ {s: 'xr__'},
					_ {s: 'w400 mr30'},
						_ Button, {s: 'mb20', kind: 'login', type: 'submit', onClick, wait, success}, 'Sign up'
					_ {s: 'w400'},
						_ Button, {s: 'mb20', kind: 'login', type: 'submit', onClick, wait, success, disabled: true}, 'Sign up'

			_ Item, {desc: 'look: outline'},
				_ {s: 'xr__'},
					_ {s: 'w400 mr30'},
						_ Button, {s: 'mt30', kind: 'login', look: 'outline', onClick, wait, success},
							_ {s: 'xrcc posr'},
								_ SVGgoogle, {s: 'w20 lef0 posa'}
								_ {}, 'Accept and continue'
					_ {s: 'w400'},
						_ Button, {s: 'mb20', kind: 'login', look: 'link', type: 'submit', onClick, wait, success}, 'Click here on link'

		_ Box1, {title: 'Kind = pill'},
			_ Item, {desc: 'look: default'},
				_ {s: 'xr__'},
					_ Button, {kind: 'pill', onClick, wait, success, s: 'mr10'}, 'Start'
					_ Button, {kind: 'pill', disabled: true, onClick, wait, success}, 'Start'
			_ Item, {desc: 'look: red'},
				_ {s: 'xr__'},
					_ Button, {kind: 'pill', look: 'red', onClick, wait, success, s: 'mr10'}, 'Reload'
					_ Button, {kind: 'pill', look: 'red', disabled: true, onClick, wait, success}, 'Reload'
			_ Item, {desc: 'look: blue'},
				_ {s: 'xr__'},
					_ Button, {kind: 'pill', look: 'blue', onClick, wait, success, s: 'mr10'}, 'Click'
					_ Button, {kind: 'pill', look: 'blue', disabled: true, onClick, wait, success}, 'Click'
			_ Item, {desc: 'look: text'},
				_ {s: 'xr__'},
					_ Button, {kind: 'pill', look: 'text', onClick, wait, success, s: 'mr10'}, 'Click'
					_ Button, {kind: 'pill', look: 'text', disabled: true, onClick, wait, success}, 'Click'

		_ Box1, {title: 'Kind = link'},
			_ Item, {desc: 'look: default'},
				_ {s: 'xr__'},
					_ Button, {kind: 'link', onClick, wait, success, s: 'mr10'}, 'Link'

		_ Box1, {title: 'Kind = small'},
			_ Item, {desc: 'look: default'},
				_ {s: 'xr__'},
					_ Button, {kind: 'small', onClick, wait, success, s: 'mr10'}, 'Start'
			_ Item, {desc: 'look: discreet'},
				_ {s: 'xr__'},
					_ Button, {kind: 'small', look: 'discreet', onClick, wait, success, s: 'mr10'}, 'Start'



LinkButtonDemo = () ->
	fake = useCall2 ->
		await sleep 2000

	onClick = fake.call
	wait = fake.wait

	_ Box, {title: 'LinkButton'},
		_ Box1, {title: 'LinkButton can be any button and supports href'},
			_ Item, {desc: ''},
				_ {s: 'xr__'},
					_ LinkButton, {kind: 'pill', href: {test: (x) -> if !x then 1 else parseInt(x) + 1}, wait, s: 'mr10'}, 'Link'
					_ LinkButton, {s: 'mb20', href: '?test=123', kind: 'rounded', color: 'sea', onClick, wait}, 'Save'
					_ LinkButton, {s: 'mb20', href: 'mailto:hello@timeadore.com?subject=Hello',
					target: "_blank", rel: "noopener noreferrer", kind: 'rounded', look: 'text', onClick, wait}, 'Mailto'




SpinnerDemo = () ->
	_ Box, {title: 'Spinner'},
		_ Item, {desc: 'kind: jumpingBalls'},
			_ {s: 'bordbk-3 posr w100 h100'},
				_ Spinner, {clr: 'bue-2', scale: 1.5}

		_ Item, {desc: 'kind: pulse'},
			_ {s: 'bordbk-3 posr w100 h100 bgbk'},
				_ Spinner, {kind: 'pulse', clr: 'bue-2', scale: 1.0}

TooltipDemo = () ->

	_ Box, {title: 'Tooltip'},

		_ Item, {},
			_ {s: 'xr__'},
				_ {s: 'mr40'},
					_ {s: 'bg1 p20 hoc1(op1) posr'},
						_ {}, 'direction = up (default)',
						_ Tooltip, {s: '_fade1', className: 'c1'},
							_ {s: 'whn p10_20'}, 'This is a tooltip'
							
				_ {s: 'mr40'},
					_ {s: 'bg1 p20 hoc1(op1) posr'},
						_ {}, 'direction = right',
						_ Tooltip, {s: '_fade1', direction: 'right', className: 'c1'},
							_ {s: 'whn p10_20'}, 'This is a tooltip'
							
				_ {s: 'mr40'},
					_ {s: 'bg1 p20 hoc1(op1) posr'},
						_ {}, 'direction = down',
						_ Tooltip, {s: '_fade1', direction: 'down', className: 'c1'},
							_ {s: 'whn p10_20'}, 'This is a tooltip'

				_ {s: 'mr40'},
					_ {s: 'bg1 p20 hoc1(op1) posr'},
						_ {}, 'direction = left',
						_ Tooltip, {s: '_fade1', direction: 'left', className: 'c1'},
							_ {s: 'whn p10_20'}, 'This is a tooltip'









