module Distribution.Nixpkgs.Haskell.Cabal.Project where
----------------------------------------
import  Prelude_project2nix

----------------------------------------
import Distribution.Nixpkgs.Haskell.Cabal.Condition.Types

----------------------------------------
import qualified "Cabal" Distribution.Types.CondTree                  as Cabal
import qualified "Cabal" Distribution.Types.Condition                 as Cabal

import "cabal-install" Distribution.Client.ProjectConfig
import "cabal-install" Distribution.Client.ProjectConfig.Types
-- import "cabal-install" Distribution.Client.ProjectConfig.Legacy

----------------------------------------

----------------------------------------
