import React from 'react'

import SVGgoogle from 'icons/google.svg'
import {useCall2} from 'uilib/reactUtils'
import {sleep} from 'comon/shared'

import Button from './Button'
import Spinner from './Spinner'

import {_} from 'setup'

export default Demo = () ->
	_ {},
		_ ButtonDemo, {}
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

	_ Box, {title: 'Button'},

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

			_ Item, {desc: 'look: link'},
				_ {s: 'xr__'},
					_ {s: 'w400 mr30'},
						_ Button, {s: 'mt40', look: 'link', onClick, wait}, 'No account? Sign up for FREE'
						_ Button, {look: 'link', href: '/login'}, 'Already have an account? Sign in'

					_ {s: 'w400'}

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
