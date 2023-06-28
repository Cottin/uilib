import React from 'react'
import {useRouter} from 'next/router'
import NextLink from 'next/link'

import {prepareNavigate} from 'comon/client/clientUtils'


export default Link = ({href, spec, children, ...rest}) ->
  router = useRouter()
  hrefToUse = if spec then prepareNavigate router, spec else href

  _ NextLink, {href: hrefToUse, prefetch: false, shallow: true, ...rest},
    children
