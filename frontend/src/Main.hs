{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE JavaScriptFFI #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import Data.Maybe
  (Maybe)
import GHC.Generics
  (Generic)
import GHCJS.Foreign.Callback
  (asyncCallback)
import GHCJS.Marshal
  (FromJSVal, ToJSVal, fromJSVal, toJSVal)
import GHCJS.Types
  (JSVal, jsval)

-- synchronous implementation (using $c)
foreign import javascript interruptible "setTimeout($c, $1);"
  delay :: Int -> IO ()

-- synchronous implementation (using $c), returns its second argument
foreign import javascript interruptible "setTimeout($c, $1, $2);"
  delayWithOneCbArg :: Int -> Int -> IO Int

-- synchronous implementation (using $c), returns its second and third arguments
foreign import javascript interruptible "setTimeout(function (a, b) { $c(a, b); }, $1, $2, $3);"
  delayWithTwoCbArgs :: Int -> Int -> Int -> IO (Int, Int)

-- asynchronous implementation, returns immediately
-- callback (first argument) will be executed on a separate thread
foreign import javascript unsafe "setTimeout($1, $2)"
  setTimeout :: JSVal -> Int -> IO Int

-- writes any JS value to console
foreign import javascript unsafe "console.log($1)"
  console_log :: JSVal -> IO ()

-- returns JS object
foreign import javascript unsafe "{ a: 'meow', b: 0 }"
  getJsObject :: IO JSVal

-- function to use as a callback
f :: IO ()
f = print "callback called by setTimeout (jsval cb) 1000"

-- data convertible to and from JS value
data Foo = Foo {a :: String, b :: Int} deriving (Generic, ToJSVal, FromJSVal, Show)

-- helper function for converting
jsobjToFoo :: JSVal -> IO (Maybe Foo)
jsobjToFoo = fromJSVal

main :: IO ()
main = do
  delay 1000
  print "after delay 1000"

  v1 <- delayWithOneCbArg 1000 1
  print $ "after delayWithOneCbArg 1000 1, result = " <> show v1

  v2 <- delayWithTwoCbArgs 1000 1 2
  print $ "after delayWithTwoCbArgs 1000 1 2, result = " <> show v2

  -- WARN: real code must call releaseCallback at some point
  cb <- asyncCallback f
  v3 <- setTimeout (jsval cb) 1000
  print $ "setTimeout (jsval cb) 1000, async, result = " <> show v3

  print "passing Foo { a=\"hello\", b=1 } to JS:"
  jsv <- toJSVal Foo { a="hello", b=1 }
  console_log jsv

  jsobj <- getJsObject
  v4 <- jsobjToFoo jsobj
  print $ "got { a: 'meow', b: 0 } from JS: " <> show v4
