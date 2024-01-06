import _type from "ramda/es/type"; #auto_require: _esramda
import {} from "ramda-extras" #auto_require: esramda-extras
import React from 'react'
import {useRouter} from 'next/router'
import NextLink from 'next/link'

import {prepareNavigate} from 'comon/client/clientUtils'

import Button from './Button2'


# Separate LinkButton that wraps normal Button.
# We don't want to support href in Button since then every button will useRouter which seems unnessesary
export default LinkButton = ({href, scroll = false, target, rel, children, ...rest}) ->
  router = useRouter()
  hrefToUse = if _type(href) == 'String' then href else prepareNavigate(router, href)

  _ NextLink, {href: hrefToUse, prefetch: false, shallow: true, target, rel, scroll},
    _ Button, {children, ...rest}
    
