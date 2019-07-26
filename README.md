# Reflex / GHCJS JS FFI Examples

WARN: This project can't be built with GHC because it doesn't have jsaddle-based implementation (yet).

Use `bin/build` or `bin/build-cabal` for building and `bin/open-page` or `bin/open-page-cabal` for opening resulting HTML page. All the output goes to the browser console. Refresh page after opening the console to see all the delays in the real time.

WARN: You don't usually need to create your own stuff based on `setTimeout` since ghcjs-dom already has such functionality ready to use. Implementations in this project are provided just as examples. Use them to learn how to implement things that are missing in ghcjs-dom.

NOTE: For more info on `bin/*` commands, see [reflex-template](https://github.com/dimsmol/reflex-template).

## docs

- [Foreign Function Interface](https://github.com/ghcjs/ghcjs/blob/master/doc/foreign-function-interface.md)
- [ghcjs-base README](https://github.com/ghcjs/ghcjs-base)
- [A few examples of Foreign Function Interface](https://github.com/ghcjs/ghcjs/wiki/A-few-examples-of-Foreign-Function-Interface) (partially outdated)

## libs to look at

- [ghcjs-base](http://hackage.haskell.org/package/ghcjs-base) - primitives you'll need
- [ghcjs-dom](http://hackage.haskell.org/package/ghcjs-dom) - web browser API, includes these parts:
  - [ghcjs-dom-jsffi](http://hackage.haskell.org/package/ghcjs-dom-jsffi) - JS FFI implementation (for GHCJS)
  - [ghcjs-dom-jsaddle](http://hackage.haskell.org/package/ghcjs-dom-jsaddle) - jsaddle-based implementation (for GHC)

## having code for both GHC and GHCJS

Usually, you want to have implementation of the needed API with both JS FFI (to use with GHCJS) and jsaddle (to use with GHC). You can use cabal conditional directives and C preprocessor to use proper implementation depending on compiler. Some examples of how this can be done:

- ghcjs-dom uses:
  - `#ifdef` directives:
    - [GHCJS.DOM.Document](https://github.com/ghcjs/ghcjs-dom/blob/d17a8078b05e7b06dc2ad5553016181c20bd2f83/ghcjs-dom/src/GHCJS/DOM/Document.hs) (WARN: link to specific commit, can be outdated)
    - [jsffi mentions](https://github.com/ghcjs/ghcjs-dom/search?q=ghcjs-dom-jsffi)
  - condition on `flag(jsffi)` in [cabal](https://github.com/ghcjs/ghcjs-dom/blob/d17a8078b05e7b06dc2ad5553016181c20bd2f83/ghcjs-dom/ghcjs-dom.cabal) to use different packages (WARN: link to specific commit, can be outdated)
- reflex-dom uses condition on `ghcjs` in [cabal](https://github.com/reflex-frp/reflex-dom/blob/adeee9dda8ab7253481c09414d169dac1ad027e3/reflex-dom-core/reflex-dom-core.cabal) to use different source files and packages (WARN: link to specific commit, can be outdated)

## misc

ghc-dom implementation of `setTimeout` is in [WindowOrWorkerGlobalScope.hs](https://github.com/ghcjs/ghcjs-dom/blob/d17a8078b05e7b06dc2ad5553016181c20bd2f83/ghcjs-dom-jsffi/src/GHCJS/DOM/JSFFI/Generated/WindowOrWorkerGlobalScope.hs#L33) (WARN: link to specific commit, can be outdated).
