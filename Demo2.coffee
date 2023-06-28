import React from 'react'

import SVGgoogle from 'icons/google.svg'
import {useCall2} from 'uilib/reactUtils'
import {sleep} from 'comon/shared'

import Button from './Button2'
import Spinner from './Spinner2'
import Tooltip from './Tooltip'

import {useFela, colors} from 'setup'

export default Demo = () ->
	_ {},
		# _ {}, 'test123'
		_ ButtonDemo, {}
		_ TooltipDemo, {}
		# _ SpinnerDemo, {}


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

	_ Box, {title: 'Button'},

		_ Box1, {title: 'Kind = rounded'},


			_ Item, {desc: 'look: default'},
				_ {s: 'xr__'},
					_ {s: 'mr10'},
						_ Button, {s: 'mb20', kind: 'rounded', onClick, wait}, 'Save'
					_ {s: 'mr10'},
						_ Button, {s: 'mb20', kind: 'rounded', onClick, wait, disabled: true}, 'Save'
					_ {s: 'mr10'},
						_ Button, {s: 'mb20', kind: 'rounded', scale: 0.6, onClick, wait}, 'Scale 0.6'
					_ {s: 'mr10'},
						_ Button, {s: 'mb20', kind: 'rounded', scale: 0.7, onClick, wait}, 'Scale 0.7'
					_ {s: 'mr10'},
						_ Button, {s: 'mb20', kind: 'rounded', scale: 0.8, onClick, wait}, 'Scale 0.8'
					_ {s: 'mr10'},
						_ Button, {s: 'mb20', kind: 'rounded', scale: 0.9, onClick, wait}, 'Scale 0.9'
					_ {s: 'mr10'},
						_ Button, {s: 'mb20', kind: 'rounded', scale: 1.1, onClick, wait}, 'Scale 1.1'
					_ {s: 'mr10'},
						_ Button, {s: 'mb20', kind: 'rounded', scale: 1.2, onClick, wait}, 'Scale 1.2'

			_ Item, {desc: 'look: default, color: sea'},
				_ {s: 'xr__'},
					_ {s: 'mr10'},
						_ Button, {s: 'mb20', kind: 'rounded', color: 'sea', onClick, wait}, 'Save'
					_ {s: 'mr10'},
						_ Button, {s: 'mb20', kind: 'rounded', color: 'sea', onClick, wait, disabled: true}, 'Save'

			_ Item, {desc: 'look: text'},
				_ {s: 'xr__'},
					_ {s: 'mr10'},
						_ Button, {s: 'mb20', kind: 'rounded', look: 'text', onClick, wait}, 'Cancel'
					_ {s: 'mr10'},
						_ Button, {s: 'mb20', kind: 'rounded', look: 'text', onClick, wait, disabled: true}, 'Cancel'

		_ Box1, {title: 'Kind = login'},


			_ Item, {desc: 'look: default'},
				_ {s: 'xr__'},
					_ {s: 'w400 mr30'},
						_ Button, {s: 'mb20', type: 'submit', onClick, wait}, 'Sign up'
					_ {s: 'w400'},
						_ Button, {s: 'mb20', type: 'submit', onClick, wait, disabled: true}, 'Sign up'

			_ Item, {desc: 'look: outline'},
				_ {s: 'xr__'},
					_ {s: 'w400 mr30'},
						_ Button, {s: 'mt30', look: 'outline', onClick, wait},
							_ {s: 'xrcc posr'},
								_ SVGgoogle, {s: 'w20 lef0 posa'}
								_ {}, 'Accept and continue'
					_ {s: 'w400'}

			# _ Item, {desc: 'look: link'},
			# 	_ {s: 'xr__'},
			# 		_ {s: 'w400 mr30'},
			# 			_ Button, {s: 'mt40', look: 'link', onClick, wait}, 'No account? Sign up for FREE'
			# 			_ Button, {look: 'link', href: '/login'}, 'Already have an account? Sign in'

			# 		_ {s: 'w400'}

		_ Box1, {title: 'Kind = pill'},
			_ Item, {desc: 'look: default'},
				_ Button, {kind: 'pill', onClick, wait}, 'Start'




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









