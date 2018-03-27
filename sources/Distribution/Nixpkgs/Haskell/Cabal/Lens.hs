-- {-# LANGUAGE  #-}
-- {-# LANGUAGE OverloadedStrings #-}
-- {-# LANGUAGE OverloadedLists #-}

{-| 

@

>> 

@

-}
module Distribution.Nixpkgs.Haskell.Cabal.Lens
 ( module Distribution.Nixpkgs.Haskell.Cabal.Lens
 ) where
----------------------------------------
import Prelude.Distribution.Nixpkgs.Haskell.Cabal

----------------------------------------
import Distribution.Nixpkgs.Haskell.Cabal.Condition.Types 

----------------------------------------
import "lens" Control.Lens as L

--import qualified "Cabal" Distribution.Types.BuildInfo                 as Cabal
import qualified "Cabal" Distribution.Types.CondTree                  as Cabal
import qualified "Cabal" Distribution.Types.Condition                 as Cabal
--import qualified "Cabal" Distribution.Types.Dependency                as Cabal
--import qualified "Cabal" Distribution.Types.GenericPackageDescription as Cabal
--import qualified "Cabal" Distribution.Types.PackageDescription        as Cabal

----------------------------------------

----------------------------------------

-- CondTree'ConfigurationVariable

-- type ConditionalLibrary = Maybe (Conditional Library)

-- type ConditionalComponents a =
--   [( UnqualComponentName
--    , Conditional a
--    )]

----------------------------------------

traverseConditional
  :: Traversal (Conditional a) (Conditional b) a b
traverseConditional = traverse

-- traverseConditions'GenericPackageDescription
--  :: Traversal' GenericPackageDescription (Condition ConfVar)
-- traverseConditions'GenericPackageDescription f =
--  \GenericPackageDescription{..} -> GenericPackageDescription
--    <$> (Cabal.packageDescription & pure)  -- :: PackageDescription
--    <*> (Cabal.genPackageFlags    & pure)  -- :: [Flag]
  
--    -- :: Maybe (CondTree ConfVar [Dependency] Library)
--    <*> (Cabal.condLibrary &
--          traverse (traverseConditions'CondTree f))
   
--    -- :: [( UnqualComponentName, CondTree ConfVar [Dependency] _ )]
--    <*> (Cabal.condSubLibraries   & go)
--    <*> (Cabal.condForeignLibs    & go)
--    <*> (Cabal.condExecutables    & go)
--    <*> (Cabal.condTestSuites     & go)
--    <*> (Cabal.condBenchmarks     & go)
  
--  where
--  go = (traverseConditions'CondTree f)

----------------------------------------

getConditions
  :: Cabal.CondTree v c a
  -> [Cabal.Condition v]
getConditions = (^.. traverseConditions'CondTree)

traverseConditions'CondTree
 :: Traversal
     (Cabal.CondTree  v c a) (Cabal.CondTree  w c a)
     (Cabal.Condition v)     (Cabal.Condition w)
traverseConditions'CondTree f (Cabal.CondNode a c ifs) = Cabal.CondNode a c
 <$> traverse (traverseConditions'CondBranch f) ifs

traverseConditions'CondBranch
 :: Traversal
     (Cabal.CondBranch  v c a) (Cabal.CondBranch  w c a)
     (Cabal.Condition   v)     (Cabal.Condition   w)
traverseConditions'CondBranch f (Cabal.CondBranch cnd t me) = Cabal.CondBranch
 <$> f cnd
 <*> traverseConditions'CondTree f            t
 <*> traverseConditions'CondTree f `traverse` me

----------------------------------------