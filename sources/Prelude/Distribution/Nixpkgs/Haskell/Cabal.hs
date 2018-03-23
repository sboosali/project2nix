-- {-# LANGUAGE  #-}

{-| The package-specific custom prelude, which re-exports 
another custom ('Prelude.Spiros' from the @spiros@ package). 

-}
module Prelude.Distribution.Nixpkgs.Haskell.Cabal
 ( module Prelude.Spiros
 -- , module Prelude.Distribution.Nixpkgs.Haskell.Cabal
 -- , module X
 ) where

----------------------------------------

-- import as X

import "spiros" Prelude.Spiros hiding (ByteString)


----------------------------------------

----------------------------------------
