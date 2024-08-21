import _equals from "ramda/es/equals"; import _map from "ramda/es/map"; import _replace from "ramda/es/replace"; import _toPairs from "ramda/es/toPairs"; #auto_require: _esramda
import {mapI, $} from "ramda-extras" #auto_require: esramda-extras

import React, {useState, useRef, useEffect, useLayoutEffect} from 'react'
import {Flipper, Flipped} from "react-flip-toolkit"
import dynamic from 'next/dynamic'
 
import SVGgoogle from 'icons/google.svg'
import SVGpen from 'icons/pen.svg'
import SVGduplicate from 'icons/duplicate.svg'
import {useCall} from 'uilib/reactUtils'
import {sleep} from 'comon/shared'

import Button from './Button'
import LinkButton from './LinkButton'
import Spinner from './Spinner'
import Tooltip from './Tooltip'
import Tooltip2 from './Tooltip2'
import Dropdown from './Dropdown'
import Switch from './Switch'
import Calendar from './Calendar'
import Textbox from './Textbox'
import LineChart from './LineChart'
import icons from 'icons'

import {useFela, colors} from 'setup'

LoadingSkel = () ->
	_ {s: 'w100% _skelbk-2 fabk-47-14 fsi p10_15 outgyc-2 bgwh br4'}, 'Loading currencies'

# ```
# const DynamicDropdownCurrency = dynamic(() => import('./DropdownCurrency'), {
# 	ssr: false,
# 	loading: () => <LoadingSkel />,
# })
# ```
DynamicDropdownCurrency = () -> 'Comment back in again if your project uses currency'

export default Demo = () ->
	_ {},
		_ LineChartDemo, {}
		_ CalendarDemo, {}
		_ ButtonDemo, {}
		_ Tooltip2Demo, {}
		_ TooltipDemo, {}
		_ DropdownDemo, {}
		_ TextboxDemo, {}
		_ SwitchDemo, {}
		_ LinkButtonDemo, {}
		_ SpinnerDemo, {}
		_ IconDemo, {}

Box = ({title, s, children}) -> 
	_ {s: "bgwh bordbk-1 p30_10_10_10 m20 posr #{s}"},
		_ {s: 'posa top-10 bgbk bordbk-1 p2_10 br3 fawh-97-14'}, title
		children

Box1 = ({s, s2, title, children}) -> 
	_ {s: "borlbk-1 p30_10_10_10 m20 posr #{s2}"},
		_ {s: 'posa top-10 lef-5 bgbk>5 bordbk-1 p2_10 br3 fawh-97-14'}, title
		_ {s: "#{s}"},
			children

Item = ({s, desc, children}) ->
	_ {s: "mb20 #{s} xc__"},
		children
		if desc then _ {s: 'fabk-36-12'}, desc


ButtonDemo = () ->
	fake = useCall ->
		await sleep 2000

	onClick = fake.call
	wait = fake.wait
	success = fake.success

	_ Box, {title: 'Button'},

		_ Box1, {title: 'Kind = popup'},

			_ Item, {desc: 'look: default'},
				_ {s: 'xr__'},
					_ {s: 'mr10 w400 bg1 p20'},
						_ {s: 'bgbe _sh2 br10'},
							_ {s: 'xrcc p30'}, 'Popup'
							_ {s: 'xrac'},
								_ Button, {s: '', kind: 'popup', look: 'text', onClick, wait, success}, 'Cancel'
								_ Button, {s: '', kind: 'popup', look: 'blue', onClick, wait, success}, 'Save'

					_ {s: 'mr10 w400 bg1 p20'},
						_ {s: 'bgbe _sh2 br10'},
							_ {s: 'xrcc p30'}, 'disabled'
							_ {s: 'xrac'},
								_ Button, {s: '', kind: 'popup', look: 'text', disabled: true, onClick, wait, success}, 'Cancel'
								_ Button, {s: '', kind: 'popup', look: 'blue', disabled: true, onClick, wait, success}, 'Save'

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
					# _ {s: 'mr10 h80'},
						# _ Button, {s: 'mb10', type: 'submit', wait}, 'Sign in'


			_ Item, {desc: 'look: default, color: sea, coral, azure'},
				_ {s: 'xr__'},
					_ {s: 'mr10'},
						_ Button, {s: 'mb20', kind: 'rounded', color: 'sea', onClick, wait, success}, 'Save'
					_ {s: 'mr10'},
						_ Button, {s: 'mb20', kind: 'rounded', color: 'sea', onClick, wait, success, disabled: true}, 'Save'
					_ {s: 'mr10'},
						_ Button, {s: 'mb20', kind: 'rounded', color: 'coral', onClick, wait, success}, 'Save'
					_ {s: 'mr10'},
						_ Button, {s: 'mb20', kind: 'rounded', color: 'coral', onClick, wait, success, disabled: true}, 'Save'
					_ {s: 'mr10'},
						_ Button, {s: 'mb20', kind: 'rounded', color: 'azure', onClick, wait, success}, 'Save'
					_ {s: 'mr10'},
						_ Button, {s: 'mb20', kind: 'rounded', color: 'azure', onClick, wait, success, disabled: true}, 'Save'

			_ Item, {desc: 'look: text'},
				_ {s: 'xr__'},
					_ {s: 'mr10'},
						_ Button, {s: 'mb20', kind: 'rounded', look: 'text', onClick, wait, success}, 'Cancel'
					_ {s: 'mr10'},
						_ Button, {s: 'mb20', kind: 'rounded', look: 'text', onClick, wait, success, disabled: true}, 'Cancel'

		_ Box1, {title: 'Kind = circle (must give w and h)'},
			_ Item, {desc: 'look: default'},
				_ {s: 'xr__'},
					_ {s: 'mr10 h80'},
						_ Button, {s: 'w40 h40', kind: 'circle', onClick, wait, success},
							_ SVGduplicate, {s: 'fillbk-3 w20 _fade1', className: 'c5'}

			_ Item, {desc: 'look: beige'},
				_ {s: 'xr__'},
					_ {s: 'mr10 h80'},
						_ Button, {s: 'w40 h40', kind: 'circle', look: 'beige', onClick, wait, success},
							_ SVGduplicate, {s: 'fillbk-3 w20 _fade1', className: 'c5'}

		_ Box1, {title: 'Kind = hover'},

			_ Item, {desc: 'look: default'},
				_ {s: 'xr__'},
					_ {s: 'mr10 h80'},
						_ Button, {s: 'mb20', kind: 'hover', scale: 1, onClick, wait, success}, 'Edit'
					_ {s: 'mr10 h80'},
						_ Button, {s: 'mb20', kind: 'hover', scale: 1.1, onClick, wait, success}, 'Edit'
					_ {s: 'mr10 h80'},
						_ Button, {s: 'mb20', kind: 'hover', scale: 0.9, onClick, wait, success}, 'Edit'
					_ {s: 'mr10 h80'},
						_ Button, {s: 'mb20 hofoc1(fillwh)', sChildren: 'xr_c', kind: 'hover', scale: 0.9, onClick, wait, success},
							_ SVGpen, {s: 'fillbk-3 w20 mr8 _fade1', className: 'c1'}
							_ {}, 'Edit'


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
			_ Item, {desc: 'look: noLine'},
				_ {s: 'xr__'},
					_ Button, {kind: 'link', look: 'noLine', onClick, wait, success, s: 'mr10'}, 'Link'

		_ Box1, {title: 'Kind = small'},
			_ Item, {desc: 'look: default'},
				_ {s: 'xr__'},
					_ Button, {kind: 'small', onClick, wait, success, s: 'mr10'}, 'Start'
			_ Item, {desc: 'look: discreet'},
				_ {s: 'xr__'},
					_ Button, {kind: 'small', look: 'discreet', onClick, wait, success, s: 'mr10'}, 'Start'



LinkButtonDemo = () ->
	fake = useCall ->
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


SwitchDemo = () ->
	[flag, setFlag] = useState false
	_ Box, {title: 'Switch'},
		_ Box1, {title: 'Normal'},
			_ Item, {desc: 'Scale 0.8 ... 1.2'},
				_ {s: 'xr__'},
					_ Switch, {s: 'mr15', scale: 0.8, value: flag, onChange: (val) -> setFlag val}
					_ Switch, {s: 'mr15', scale: 0.9, value: flag, onChange: (val) -> setFlag val}
					_ Switch, {s: 'mr15', scale: 1.0, value: flag, onChange: (val) -> setFlag val}
					_ Switch, {s: 'mr15', scale: 1.1, value: flag, onChange: (val) -> setFlag val}
					_ Switch, {s: 'mr15', scale: 1.2, value: flag, onChange: (val) -> setFlag val}

		_ Box1, {title: 'look = dark'},
			_ Item, {desc: ''},
				_ {s: 'bgbk p10'},
					_ Switch, {s: 'mr15', look: 'dark', scale: 0.8, value: flag, onChange: (val) -> setFlag val}

TextboxDemo = () ->
	[text, setText] = useState 'test'

	onChange = (newText) ->
		console.log 'onChange', newText
		setText newText

	_ Box, {title: 'Textbox'},
		_ Box1, {title: 'kind = box (default)'},
			_ Item, {desc: ''},
				_ Textbox, {s: 'xw200', placeholder: 'Write something', value: text, onChange}
		_ Box1, {title: 'kind = soft'},
			_ Item, {desc: ''},
				_ Textbox, {s: 'xw200', kind: 'soft', placeholder: 'Write something', value: text, onChange}
			_ Item, {desc: 'mask = number'},
				_ Textbox, {s: 'xw200', kind: 'soft', mask: 'number', placeholder: 'Write something', value: text, onChange}

DropdownDemo = () ->
	countries = [
		{text: 'Sweden', continent: 'Europe'}, {text: 'Norway', continent: 'Europe'},
		{text: 'Denmark', continent: 'Europe'}, {text: 'Finland', continent: 'Europe'},
		{text: 'Iceland', continent: 'Europe'}, {text: 'Northern Mariana Islands', continent: 'Unknown'}]
	[selected, setSelected] = useState null

	onChange = (item) ->
		setSelected item

	_ Box, {title: 'Dropdown'},
		_ Box1, {title: ''},
			_ Item, {desc: ''},
				_ Dropdown, {s: 'xw200', placeholder: 'Select country', items: countries, onChange, selected}
			_ Item, {desc: ''},
				_ Dropdown, {s: 'xw200', placeholder: 'Select country', error: true, items: countries, onChange, selected}
		_ Box1, {title: 'Disabled'},
			_ Item, {desc: ''},
				_ Dropdown, {s: 'xw200', placeholder: 'Select country', items: countries, onChange, selected, disabled: true}
		_ Box1, {title: 'custom items'},
			_ Item, {desc: ''},
				_ Dropdown, {s: 'xw200', placeholder: 'Select country', items: countries, onChange, selected,
				renderSelected: () ->
					_ {s: 'xc_s'},
						_ {}, selected.text
						_ {s: 'fabk-46-11'}, selected.continent
				renderItem: ({item, idx, i}) ->
						sIdx = idx == i && 'bggyb-5'
						sSel = _equals(selected, item) && "bgbue fawh ho(bgbue<1) #{idx == i && 'bgbue<1'}"
						_ {s: "p10_20 ho(bggyb-5) #{sIdx} #{sSel} _fade3 useln whn", key: item.text,
						onClick: -> onChange item},
							_ {}, item.text
							_ {s: 'fabk-46-11'}, item.continent
				}


		# _ Box1, {title: 'Auto complete'},
		# 	_ Item, {desc: ''},
		# 		_ Dropdown, {s: 'xw200', placeholder: 'Select country', items: countries, onChange, selected,
		# 		autoComplete: true}
		_ AutoCompleteSub, {}

		_ AutoCompleteGroupedSub, {}

		_ DropdownCurrencySub, {}


AutoCompleteSub = () ->
	words = ['win', 'wind', 'winded', 'winder', 'window', 'winds', 'windy', 'wine', 'winery', 'wing', 'wings', 'wink', 'winner', 'winning', 'winter', 'wintery', 'wide', 'widen', 'wider', 'widow', 'width', 'wild', 'wilder', 'will', 'willow', 'willing', 'wilt', 'wily', 'wish', 'wished', 'wisp', 'wispy', 'wise', 'wiser', 'wisdom', 'wit', 'witch', 'with', 'witless', 'witty']
	# words = ['win', 'wind', 'winded', 'winder', 'window', 'winds', 'windy', 'wine']
	[selected, setSelected] = useState null

	onChange = (item) ->
		console.log 'onChange', item
		setSelected item

	_ Box1, {title: 'Auto complete'},
		_ Item, {desc: ''},
			_ Dropdown, {s: 'xw200', placeholder: 'Select country', items: words, onChange, selected,
			autoComplete: true}
			_ Dropdown, {s: 'xw200 mt50', placeholder: 'Select country', items: words, onChange, selected,
			autoComplete: true, disabled: true}

AutoCompleteGroupedSub = () ->
	items = ['win', 'wind', 'winded', 'winder', 'window', 'winds', 'windy', 'wine', 'winery', 'wing', 'wings', 'wink', 'winner', 'winning', 'winter', 'wintery', 'wide', 'widen', 'wider', 'widow', 'width', 'wild', 'wilder', 'will', 'willow', 'willing', 'wilt', 'wily', 'wish', 'wished', 'wisp', 'wispy', 'wise', 'wiser', 'wisdom', 'wit', 'witch', 'with', 'witless', 'witty']
	groupBy = (item) -> item.substring(0, 3).toUpperCase()
	[selected, setSelected] = useState null
	onChange = (item) -> 
		console.log 'onChange', item
		setSelected item

	_ Box1, {title: 'Auto complete'},
		_ Item, {desc: ''},
			_ Dropdown, {s: 'xw200', placeholder: 'Select country', items, groupBy, onChange, selected, autoComplete: true}

DropdownCurrencySub = () ->
	[selected, setSelected] = useState null

	onChange = (item) ->
		console.log 'onChange', item
		setSelected item

	didLoad = (countries) ->
		console.log 'didLoad', countries

	_ Box1, {title: 'Currency'},
		_ Item, {desc: ''},
			_ DynamicDropdownCurrency, {s: 'xw200', selected, onChange, didLoad}


SpinnerDemo = () ->
	_ Box, {title: 'Spinner'},
		_ Item, {desc: 'kind: jumpingBalls'},
			_ {s: 'bordbk-3 posr w100 h100'},
				_ Spinner, {clr: 'bue-2', scale: 1.5}

		_ Item, {desc: 'kind: pulse'},
			_ {s: 'bordbk-3 posr w100 h100 bgbk'},
				_ Spinner, {kind: 'pulse', clr: 'bue-2', scale: 1.0}

		_ Item, {desc: 'Skeleton'},
				_ {s: 'h30 w100% _skelbk-2'}

Tooltip2Demo = () ->

	_ Box, {title: 'Tooltip 2 (portal version = use if needed for zIndex purposes)'},

		_ Box1, {title: 'Directions'},
			_ Item, {},
				_ {s: 'xr__'},
					_ {s: 'mr40'},
						_ Tooltip2, {text: _ {s: 'whn p10_20'}, 'This is a tooltip'},
							_ {s: 'bg1 p20 hoc1(op1) posr'},
								_ {}, 'direction = up (default)',

					_ {s: 'mr40'},
						_ Tooltip2, {direction: 'right', text: _ {s: 'whn p10_20'}, 'This is a tooltip'},
							_ {s: 'bg1 p20 hoc1(op1) posr'},
								_ {}, 'direction = right',

					_ {s: 'mr40'},
						_ Tooltip2, {direction: 'down', text: _ {s: 'whn p10_20'}, 'This is a tooltip'},
							_ {s: 'bg1 p20 hoc1(op1) posr'},
								_ {}, 'direction = down',

					_ {s: 'mr40'},
						_ Tooltip2, {direction: 'left', text: _ {s: 'whn p10_20'}, 'This is a tooltip'},
							_ {s: 'bg1 p20 hoc1(op1) posr'},
								_ {}, 'direction = left',
								

TooltipDemo = () ->

	_ Box, {title: 'Tooltip'},

		_ Box1, {title: 'Directions'},
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

		_ Box1, {title: 'Keep tooltip open on hover (wrap and use pea)'},

			_ Item, {desc: 'Problem: TRY MARKING THIS + when hovering on tooltip, the more right gets priority'},
				_ {s: 'xr__'},

					_ {s: 'posr hoc1(op1) posr'},
						_ {s: 'bg1 p20 mr2'},
							_ {}, 'A',
						_ Tooltip, {s: '_fade1 pea', direction: 'down', className: 'c1'},
							_ {s: 'whn p10_20'}, 'This is a tooltip'

					_ {s: 'posr hoc1(op1) posr'},
						_ {s: 'bg1 p20 mr2'},
							_ {}, 'B',
						_ Tooltip, {s: '_fade1 pea', direction: 'down', className: 'c1'},
							_ {s: 'whn p10_20'}, 'This is a tooltip'

					_ {s: 'posr hoc1(op1) posr'},
						_ {s: 'bg1 p20 mr2'},
							_ {}, 'C',
						_ Tooltip, {s: '_fade1 pea', direction: 'down', className: 'c1'},
							_ {s: 'whn p10_20'}, 'This is a tooltip'

			_ Item, {desc: 'Workaround: use display instead of opacity. Works but kills fade'},
				_ {s: 'xr__'},

					_ {s: 'posr hoc1(op1 disu) posr'},
						_ {s: 'bg1 p20 mr2'},
							_ {}, 'A',
						_ Tooltip, {s: '_fade1 pea disn', direction: 'down', className: 'c1'},
							_ {s: 'whn p10_20'}, 'This is a tooltip'

					_ {s: 'posr hoc1(op1 disu) posr'},
						_ {s: 'bg1 p20 mr2'},
							_ {}, 'B',
						_ Tooltip, {s: '_fade1 pea disn', direction: 'down', className: 'c1'},
							_ {s: 'whn p10_20'}, 'This is a tooltip'

					_ {s: 'posr hoc1(op1 disu) posr'},
						_ {s: 'bg1 p20 mr2'},
							_ {}, 'C',
						_ Tooltip, {s: '_fade1 pea disn', direction: 'down', className: 'c1'},
							_ {s: 'whn p10_20'}, 'This is a tooltip'

CalendarDemo = () ->
	[date, setDate] = useState null
	[span, setSpan] = useState ['2023-10-03', '2023-10-14']
	[multi, setMulti] = useState new Set []#['2023-10-03', '2023-10-14']
	# [span, setSpan] = useState ['2023-10-03', '2023-10-14']
	marked = ['2023-10-05']

	onChange = (newDate) -> setDate newDate
	onChangeSpan = (newSpan) -> setSpan newSpan
	onChangeMulti = (newMulti) -> setMulti newMulti

	_ Box, {title: 'Calendar'},
		_ Box1, {title: 'mode = month', s: 'xr__'},
			_ Item, {desc: 'scale 1.0 = default', s: 'mr20'},
				_ Calendar, {selected: date, onChange}
			_ Item, {desc: 'scale 0.8', s: 'mr20'},
				_ Calendar, {selected: date, onChange, scale: 0.8}
			_ Item, {desc: 'scale 1.2', s: 'mr20'},
				_ Calendar, {selected: date, onChange, scale: 1.2}

		_ Box1, {title: 'double = true'},
			_ Item, {desc: 'Multi', s: 'mr20'},
				_ Calendar, {selected: multi, marked, double: true, onChange: onChangeMulti}
			_ {s: 'xrc_ bgbe p30'},
				_ Item, {desc: 'Look = beige', s: 'mr20'},
					_ Calendar, {selected: multi, marked, look: 'beige', double: true, onChange: onChangeMulti}
			_ {s: 'xrc_ bg5'},
				_ Item, {desc: 'Single select', s: 'mr20'},
					_ Calendar, {selected: date, double: true, onChange, dev: true}

		_ Box1, {title: 'selected = [] (range)', s: 'xr__'},
			_ Item, {desc: '', s: 'mr20'},
				_ Calendar, {selected: span, onChange: onChangeSpan}

		_ Box1, {title: 'selected = Set [] (multi)', s: 'xr__'},
			_ Item, {desc: '', s: 'mr20'},
				_ Calendar, {selected: multi, onChange: onChangeMulti}

		_ Box1, {title: 'mode = month (default)', s: 'xr__'},
			_ Item, {desc: 'scale 1.0 = default', s: 'mr20'},
				_ Calendar, {selected: date, mode: 'year', onChange}
			_ Item, {desc: 'scale 0.8'},
				_ Calendar, {selected: date, mode: 'year', onChange, scale: 0.8}
		_ Box1, {title: 'how it works'},
			_ {s: 'xrc_ bg5'},
				_ Item, {desc: 'dev = true', s: 'mr20'},
					_ Calendar, {selected: date, mode: 'year', onChange, dev: true, scale: 0.6}


labels = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep']

data = [
	$ [152, 0, null, 104, 140, 159, 182, 192, 191], mapI (value, i) -> {label: labels[i], value}
	$ [null, 154, 114, 144, null, null, 120, 102, null], mapI (value, i) -> {label: labels[i], value}
	$ [80, 132, 124, 134, 110, 120], mapI (value, i) -> {label: labels[i], value}
	$ [83, 112, 164, 174, 140, 110], mapI (value, i) -> {label: labels[i], value}
]
console.log 'data', data


chartLook =
	circle:
		default:
			fill: colors 'gyc'
		hover:
			r: 9

chartLookMulti =
	circle:
		default:
			[{}, {fill: colors('rea')}]
		hover:
			r: 9
	circleSelected:
		default:
			[{}, {fill: colors('re')}]

LineChartDemo = () ->
	[dataIdx, setDataIdx] = useState 0
	[selectedIdx, setSelectedIdx] = useState 2

	[dataIdxMulti, setDataIdxMulti] = useState 0
	[selectedIdxMulti, setSelectedIdxMulti] = useState 2

	onSwitch = () ->
		setDataIdx if dataIdx == data.length - 1 then 0 else dataIdx + 1

	onSwitchMulti = () ->
		setDataIdxMulti if dataIdxMulti == data.length - 2 then 0 else dataIdxMulti + 1

	onClick = (point) -> setSelectedIdx point.idx
	onClickMulti = (point) -> setSelectedIdxMulti point.idx

	dataToUse = $ data[dataIdx], mapI (o, i) -> {...o, ...(i == selectedIdx && {selected: true} || {})}

	enrichWithSelected = (points) -> $ points, mapI (o, i) -> {...o, ...(i == selectedIdxMulti && {selected: true} || {})}

	dataMulti = [enrichWithSelected(data[dataIdxMulti]), enrichWithSelected(data[dataIdxMulti + 1])]

	_ Box, {title: 'LineChart', s: 'bgbe'},
		_ Box1, {title: 'Basic'},
			_ Item, {desc: '', s: 'xg1 h300'},
				_ LineChart, {data: [dataToUse], s: '_sh6', look: chartLook, onClick}
				_ Button, {s: 'w80 mt20', kind: 'rounded', onClick: onSwitch}, 'Switch'

		_ Box1, {title: 'Multi-line'},
			_ Item, {desc: '', s: 'xg1 h300'},
				_ LineChart, {data: dataMulti, s: '_sh6', look: chartLookMulti, onClick: onClickMulti}
				_ Button, {s: 'w80 mt20', kind: 'rounded', onClick: onSwitchMulti}, 'Switch'


IconDemo = () ->
	_ Box, {title: 'Icons', s: ''},
		_ Item, {desc: '', s: 'xg1'},
			_ {s: 'xr__w'},
				$ icons, _toPairs, _map ([key, icon]) ->
					_ {s: 'xccc p10 ho(bgbk-1) br4 _fade1 hoc1(bg1)', key},
						_ icon.default, {s: 'w25 h25', className: 'c1'}
						_ {s: 'fabk-66-11 mt2'}, $ key, _replace(/^SVG/, '')


























