import React from 'react'
import {useRouter} from 'next/router'
import NextLink from 'next/link'

import {prepareNavigate} from 'comon/client/clientUtils'

import {_} from 'setup'


export default Link = ({href, spec, children, ...rest}) ->
  router = useRouter()
  hrefToUse = if spec then prepareNavigate router, spec else href

  _ NextLink, {href: hrefToUse, ...rest},
    children
