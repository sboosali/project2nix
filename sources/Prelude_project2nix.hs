-- {-# LANGUAGE  #-}

{-| A package-specific custom prelude.

Re-exports another custom, 'Prelude.Spiros' (from the @spiros@ package). 

-}
module  Prelude_project2nix
 ( module Prelude.Spiros
 -- , module  Prelude_project2nix
 -- , module X
 ) where

----------------------------------------

-- import as X

import "spiros" Prelude.Spiros hiding (ByteString, Strict, (<&>), index, snoc, uncons, at, KnownHaskellCompiler(..))


----------------------------------------

----------------------------------------
