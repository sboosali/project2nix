module Distribution.Nixpkgs.Haskell.Cabal.Condition.Types where

----------------------------------------
import Prelude.Distribution.Nixpkgs.Haskell.Cabal

----------------------------------------
--import qualified "Cabal" Distribution.Types.BuildInfo                 as Cabal
import qualified "Cabal" Distribution.Types.CondTree                  as Cabal
--import qualified "Cabal" Distribution.Types.Condition                 as Cabal
import qualified "Cabal" Distribution.Types.Dependency                as Cabal
import qualified "Cabal" Distribution.Types.GenericPackageDescription as Cabal
--import qualified "Cabal" Distribution.Types.PackageDescription        as Cabal

----------------------------------------

type CabalConditional a = Cabal.CondTree Cabal.ConfVar [Cabal.Dependency] a

----------------------------------------

data CondIfTree v a
  = Val a
  | If v ( CondIfTree v a ) ( CondIfTree v a )
  deriving (Show,Eq)

----------------------------------------
