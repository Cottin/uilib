 #auto_require: _esramda
import {} from "ramda-extras" #auto_require: esramda-extras

import React, {useState, useEffect} from 'react'

export default DelayedChildren = ({delay = 500, children}) ->
  [delayedChildren, setDelayedChildren] = useState children

  useEffect ->
    timeout = window.setTimeout ->
      setDelayedChildren children
    , delay

    return () -> clearTimeout timeout

  , [delay, children]

  return delayedChildren
