import _type from "ramda/es/type"; #auto_require: _esramda
import {} from "ramda-extras" #auto_require: esramda-extras

import React from 'react'
import {useRouter} from 'next/router'
import NextLink from 'next/link'

import {prepareNavigate} from 'comon/client/clientUtils'


export default Link = ({href, scroll = false, post = null, target, rel, children, ...rest}) ->
  router = useRouter()
  hrefToUse = if _type(href) == 'String' then href else prepareNavigate(router, href, post)

  _ NextLink, {href: hrefToUse, prefetch: false, shallow: true, target, rel, scroll, ...rest},
    children
