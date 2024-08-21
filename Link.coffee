import _type from "ramda/es/type"; #auto_require: _esramda
import {} from "ramda-extras" #auto_require: esramda-extras

import React from 'react'
import {useRouter} from 'next/router'
import NextLink from 'next/link'

import {prepareNavigate} from 'comon/client/clientUtils'


Link = (defaultPost) -> ({href, scroll = false, post = defaultPost, target, rel, children, ...rest}) ->
  router = useRouter()
  # if post then console.log 'Link - router', router
  hrefToUse = if _type(href) == 'String' then href else prepareNavigate(router, href, post)
  # if post then console.log 'hrefToUse', hrefToUse

  _ NextLink, {href: hrefToUse, prefetch: false, shallow: true, target, rel, scroll, ...rest},
    children


export default Link(null)

# In every project, create a components/Link component that exports SafeLink(yourPostQueryProcessorFunction)
# to ensure all Links throughout your app is safe
export SafeLink = Link