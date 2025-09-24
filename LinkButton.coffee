import _type from "ramda/es/type"; #auto_require: _esramda
import {} from "ramda-extras" #auto_require: esramda-extras
import React from 'react'
import {useRouter} from 'next/router'
import NextLink from 'next/link'

import {prepareNavigate} from 'comon/client/clientUtils'

import Button from './Button'


# Separate LinkButton that wraps normal Button.
# We don't want to support href in Button since then every button will useRouter which seems unnessesary
LinkButton = (defaultPost) ->  ({href, hard = false, scroll = false, post = defaultPost, target, rel, children, ...rest}) ->
  router = useRouter()
  hrefToUse = if _type(href) == 'String' then href else prepareNavigate(router, href, post)

  if hard
    _ 'a', {href: href, target, rel},
      _ Button, {children, ...rest}
  else
    _ NextLink, {href: hrefToUse, prefetch: false, shallow: true, target, rel, scroll},
      _ Button, {children, ...rest}
    
export default LinkButton(null)

# In every project, create a components/LinkButton component that exports SafeLinkButton(yourPostQueryProcessorFunction)
# to ensure all Links throughout your app is safe
export SafeLinkButton = LinkButton