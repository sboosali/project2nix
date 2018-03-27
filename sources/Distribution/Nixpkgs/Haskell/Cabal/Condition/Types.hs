module Distribution.Nixpkgs.Haskell.Cabal.Condition.Types where

--import qualified "Cabal" Distribution.Types.BuildInfo                 as Cabal
import qualified "Cabal" Distribution.Types.CondTree                  as Cabal
--import qualified "Cabal" Distribution.Types.Condition                 as Cabal
import qualified "Cabal" Distribution.Types.Dependency                as Cabal
import qualified "Cabal" Distribution.Types.GenericPackageDescription as Cabal
--import qualified "Cabal" Distribution.Types.PackageDescription        as Cabal

----------------------------------------

type Conditional a = Cabal.CondTree Cabal.ConfVar [Cabal.Dependency] a

----------------------------------------


----------------------------------------
