-- {-# LANGUAGE  #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE OverloadedLists #-}

{-|


= USAGE:

Once this module is loaded in ghci, run 'main' to print out 'help'. e.g.:

@
$ cabal new-repl project2nix
*REPL_project2nix> main
...
@


= NOTES:

== 'CondTree' and 'CondBranch'

are mutually-recursive. 

=== Definition

@
data CondTree v c a = 'CondNode'
    { 'condTreeData'        :: a
    , 'condTreeConstraints' :: c
    , 'condTreeComponents'  :: ['CondBranch' v c a]
    }

data CondBranch v c a = 'CondBranch'
    { 'condBranchCondition' :: 'Condition' v
    , 'condBranchIfTrue'    :: CondTree v c a
    , 'condBranchIfFalse'   :: Maybe (CondTree v c a)
    }
@

When the 'condTreeComponents' are empty, there are no 'Condition's,
a.k.a the expression is actually /unconditional/:

@
isUnconditionalCondTree :: CondTree v c a -> Maybe a
isUnconditionalCondTree CondTree{..} =
  if   'condTreeComponents' == []
  then Just 'condTreeData'
  else Nothing
@

and equivalent to @(a,c)@:

@
-- (Below are specializations and different representations of the type;
-- I'm enumerating this for myself as a reminder, because even simple recursion can get complex)

CondTree v c a

~

{ 'condTreeData'        :: a
, 'condTreeConstraints' :: c
, 'condTreeComponents'  :: ['CondBranch' v c a]
}

~

( a
, c
, ['CondBranch' v c a]
)
@

When @'condTreeComponents' == []@:

@
( x :: a
, y :: c
, []
)

~

( x :: a
, y :: c
, ()
)
~

( x :: a
, y :: c
)
@

And furthermore, by specializing @c~()@
(i.e. we don't care about the value tagging each node, we just want the value):

@
( x :: a
, y :: ()
)

~

( x :: a
, () :: ()
)

~

( x :: a
)

~

x :: a
@

So a @CondTree v c a@ wraps @a@, always "holding" at least one @a@. 


=== Example

@
build-depends: base >= 4.0
if flag(extra)
    build-depends: base >= 4.2
@

is represented by a value of type

@
'CondTree' 'ConfVar' ['Dependency'] 'BuildInfo'
@

which specializes to

@
data CondTree ConfVar [Dependency] BuildInfo = CondNode
    { condTreeData        :: BuildInfo
    , condTreeConstraints :: [Dependency]
    , condTreeComponents  :: [CondBranch ConfVar [Dependency] BuildInfo ]
    }

data CondBranch ConfVar [Dependency] BuildInfo = CondBranch
    { condBranchCondition :: Condition ConfVar
    , condBranchIfTrue    :: CondTree ConfVar [Dependency] BuildInfo
    , condBranchIfFalse   :: Maybe (CondTree ConfVar [Dependency] BuildInfo)
    }
@

a.k.a., with aliases:

@
type 'CondTreeBuildDepends'   = CondTree   ConfVar [Dependency] BuildInfo

type 'CondBranchBuildDepends' = CondBranch ConfVar [Dependency] BuildInfo

type 'ConditionConfVar' = 'Condition' 'ConfVar'

CondTreeBuildDepends
~
{ condTreeData        :: BuildInfo
, condTreeConstraints :: [Dependency]
, condTreeComponents  :: ['CondBranchBuildDepends']
}

CondBranchBuildDepends
~
{ condBranchCondition :: 'ConditionConfVar'
, condBranchIfTrue    :: 'CondTreeBuildDepends'
, condBranchIfFalse   :: Maybe 'CondTreeBuildDepends'
}

ConditionConfVar
= 'Var'  'ConfVar'
| 'Lit'  Bool
| 'CNot' 'ConditionConfVar'
| 'COr'  'ConditionConfVar' 'ConditionConfVar'
| 'CAnd' 'ConditionConfVar' 'ConditionConfVar'

@



=== Optics

===== 'traverseCondTreeV'

@
'Traversal'  (CondTree v c a) (CondTree w c a) v w
'Traversal\'' (CondTree v c a)                  v 

traverseCondTreeV f (CondNode a c ifs) =
    CondNode a c <$> traverse (traverseCondBranchV f) ifs
@

===== 'traverseCondBranchV'

@
'Traversal'   (CondBranch v c a) (CondBranch w c a) v w
'Traversal\'' (CondBranch v c a)                    v 

traverseCondBranchV f (CondBranch cnd t me) = CondBranch
    <$> traverse f cnd
    <*> traverseCondTreeV f t
    <*> traverse (traverseCondTreeV f) me
@




== Functions


==== 'extractCondition':

@
extractCondition
  :: Eq v
  => (a -> Bool) -> CondTree v c a -> Condition v 

Extract the condition matched by the given predicate from a cond tree.
We use this mainly for extracting buildable conditions.

extractCondition ('const' False) = _
extractCondition ('const' True)  = _

extractCondition ('const' False) = 'Lit' False -- ?
extractCondition ('const' True)  = 'Lit' True  -- ?


@


==== 'simplifyCondTree':

@
simplifyCondTree
  :: (Monoid a, Monoid d)
  => (v -> Either v Bool) -> CondTree v d a -> (d, a) 

Flattens a CondTree using a partial flag assignment.
When a condition cannot be evaluated, both branches are ignored.

If-Then branches (i.e. not If-Then-Else), when true, are merged with their parent via the 'Monoid'.
@






-}
module REPL_project2nix 
 ( module REPL_project2nix

 , module ProjectToNix

 , module X

 , module Cabal

 , module Prelude.Spiros 
 --, module Distribution.Types.GenericPackageDescription.Lens
 ) where

----------------------------------------
-- re-exported modules

import           ProjectToNix

import "lens" Control.Lens as X

import "Cabal" Distribution.Types.Lens as X
 -- lenses for most types
import "Cabal" Distribution.Types.GenericPackageDescription      as X ( GenericPackageDescription(GenericPackageDescription), unFlagName, mkFlagAssignment, FlagAssignment )
 --
import "Cabal" Distribution.Types.Condition   as X
import "Cabal" Distribution.Types.CondTree    as X
import "Cabal" Distribution.Types.Dependency  as X
import "Cabal" Distribution.Types.UnqualComponentName as X

import "Cabal" Distribution.Compiler  as X

import "Cabal" Distribution.Pretty as X

--import "Cabal" Distribution.PackageDescription                   as X

import "bytestring" Data.ByteString  as X  (ByteString)

import "spiros" Prelude.Spiros hiding (ByteString, Strict, (<&>), index, snoc, uncons, at, KnownHaskellCompiler(..))

----------------------------------------
-- used modules

import qualified "Cabal" Distribution.Verbosity                     as Cabal
import qualified "Cabal" Distribution.PackageDescription            as Cabal
import qualified "Cabal" Distribution.PackageDescription.Parsec     as Cabal

--import qualified "bytestring" Data.ByteString.Char8                 as BS

--import Prelude.Distribution.Nixpkgs.Haskell.Cabal

----------------------------------------
-- types

type CondTreeBuildDepends   = CondTree   ConfVar [Dependency] BuildInfo

type CondBranchBuildDepends = CondBranch ConfVar [Dependency] BuildInfo

type ConditionConfVar = Condition ConfVar

----------------------------------------

main :: IO ()
main = do
  printHelp
  where
  printHelp = help
    & traverse_ (\ls -> putStr "\n" >> traverse_ putStrLn ls)

help :: [[String]]
help = 
 [ []

 , [ ":set -XOverloadedStrings"
   ]

 , [ "g <- readCabalFile \"./data/spiros.cabal\"" 
   , "g"
   , ":t g"
   ]

 , [ "g ^.. condTestSuites"
   ]
   
 , [ "ts = g ^.. condTestSuites.traverse._2"
   , "ts"
   ]

 , [ "fs = g ^.. genPackageFlags.traverse.to(\\f -> (f ^. flagName.to(unFlagName), f ^. flagDefault))"
   , "fs"
 ]

 , [ "(d,u,s) = ts & (\\[d,u,s] -> (d,u,s))"
   ]

 , []
 , []
 ]

----------------------------------------

{-|

e.g.

-}
readCabalFile :: FilePath -> IO Cabal.GenericPackageDescription
readCabalFile = Cabal.readGenericPackageDescription Cabal.verbose


----------------------------------------

knownCompilerFlavors' :: [CompilerFlavor]
knownCompilerFlavors' = [GHC, GHCJS, NHC, YHC, Hugs, HBC, Helium, JHC, LHC, UHC]

----------------------------------------
{-EXAMPLES

example snippets from repl sessions.

> g ^.. genPackageFlags.traverse.flagName 
[FlagName "examples",FlagName "test-doctest",FlagName "test-unit",FlagName "test-static"]

> g ^.. genPackageFlags.traverse.to(\f -> (f ^. flagName, f ^. flagDefault))
[(FlagName "examples",True),(FlagName "test-doctest",True),(FlagName "test-unit",True),(FlagName "test-static",False)]



> fmap prettyShow knownCompilerFlavors'
["ghc","ghcjs","nhc98","yhc","hugs","hbc","helium","jhc","lhc","uhc"]



> ts
...


-- doctest test-suite
>

CondNode

 { condTreeData 
    = TestSuite
        { testName = UnqualComponentName "", testInterface = TestSuiteExeV10 (mkVersion [1,0]) "DocTests.hs", testBuildInfo = BuildInfo {buildable = True, buildTools = [], buildToolDepends = [], cppOptions = [], asmOptions = [], cmmOptions = [], ccOptions = [], cxxOptions = [], ldOptions = [], pkgconfigDepends = [], frameworks = [], extraFrameworkDirs = [], asmSources = [], cmmSources = [], cSources = [], cxxSources = [], jsSources = [], hsSourceDirs = ["test"], otherModules = [], virtualModules = [], autogenModules = [], defaultLanguage = Just Haskell2010, otherLanguages = [], defaultExtensions = [], otherExtensions = [], oldExtensions = [], extraLibs = [], extraGHCiLibs = [], extraBundledLibs = [], extraLibFlavours = [], extraLibDirs = [], includeDirs = [], includes = [], installIncludes = [], options = [(GHC,["-Wall"])], profOptions = [], sharedOptions = [], staticOptions = [], customFieldsBI = [], targetBuildDepends = [Dependency (PackageName "base") AnyVersion,Dependency (PackageName "spiros") AnyVersion,Dependency (PackageName "doctest") AnyVersion], mixins = []}
        }

 , condTreeConstraints
    = [ Dependency (PackageName "base") AnyVersion,Dependency (PackageName "spiros") AnyVersion,Dependency (PackageName "doctest") AnyVersion
      ]

 , condTreeComponents
    = [ CondBranch
        { condBranchCondition = CAnd (CNot (Var (Impl GHCJS AnyVersion))) (CNot (Var (Flag (FlagName "test-doctest"))))
        , condBranchIfTrue = CondNode
          { condTreeData = TestSuite {testName = UnqualComponentName "", testInterface = TestSuiteUnsupported (TestTypeUnknown "" (mkVersion [])), testBuildInfo = BuildInfo {buildable = False, buildTools = [], buildToolDepends = [], cppOptions = [], asmOptions = [], cmmOptions = [], ccOptions = [], cxxOptions = [], ldOptions = [], pkgconfigDepends = [], frameworks = [], extraFrameworkDirs = [], asmSources = [], cmmSources = [], cSources = [], cxxSources = [], jsSources = [], hsSourceDirs = [], otherModules = [], virtualModules = [], autogenModules = [], defaultLanguage = Nothing, otherLanguages = [], defaultExtensions = [], otherExtensions = [], oldExtensions = [], extraLibs = [], extraGHCiLibs = [], extraBundledLibs = [], extraLibFlavours = [], extraLibDirs = [], includeDirs = [], includes = [], installIncludes = [], options = [], profOptions = [], sharedOptions = [], staticOptions = [], customFieldsBI = [], targetBuildDepends = [], mixins = []}}, condTreeConstraints = [], condTreeComponents = []
          }
        , condBranchIfFalse = Nothing
        }
      ]
 }


i.e.


CondBranch
 { condBranchCondition
    = CAnd (CNot (Var (Impl GHCJS AnyVersion)))
           (CNot (Var (Flag (FlagName "test-doctest"))))
 , condBranchIfTrue  = CondNode {...}
 , condBranchIfFalse = Nothing
 }



-- a component/stanza without conditions

this `.cabal` stanza:

    test-suite static
    
     hs-source-dirs:      test
     main-is:             StaticTests.hs
     other-modules:
      StaticTests.Generics
    
     type:                exitcode-stdio-1.0
     default-language:    Haskell2010
     ghc-options:         -Wall 
    
     build-depends:
        base
      , spiros

becomes parsed into this `Cabal` expression:

    CondNode
    { condTreeData =
      TestSuite
       { testName = UnqualComponentName "", testInterface = TestSuiteExeV10 (mkVersion [1,0]) "StaticTests.hs", testBuildInfo = BuildInfo {buildable = True, buildTools = [], buildToolDepends = [], cppOptions = [], asmOptions = [], cmmOptions = [], ccOptions = [], cxxOptions = [], ldOptions = [], pkgconfigDepends = [], frameworks = [], extraFrameworkDirs = [], asmSources = [], cmmSources = [], cSources = [], cxxSources = [], jsSources = [], hsSourceDirs = ["test"], otherModules = [ModuleName ["StaticTests","Generics"]], virtualModules = [], autogenModules = [], defaultLanguage = Just Haskell2010, otherLanguages = [], defaultExtensions = [], otherExtensions = [], oldExtensions = [], extraLibs = [], extraGHCiLibs = [], extraBundledLibs = [], extraLibFlavours = [], extraLibDirs = [], includeDirs = [], includes = [], installIncludes = [], options = [(GHC,["-Wall"])], profOptions = [], sharedOptions = [], staticOptions = [], customFieldsBI = [], targetBuildDepends = [Dependency (PackageName "base") AnyVersion,Dependency (PackageName "spiros") AnyVersion], mixins = []}
       }
    , condTreeConstraints =
        [ Dependency (PackageName "base") AnyVersion,Dependency (PackageName "spiros") AnyVersion
        ]
    , condTreeComponents = []
    }

i.e., eliding default/mempty values, which i represent by an ellispis (and an underscore represents an unknown or unimportant value):
    
    CondNode
    { condTreeData =
        TestSuite
          { testName      = _
          , testInterface = TestSuiteExeV10 (mkVersion [1,0]) "StaticTests.hs"
          , testBuildInfo =
              BuildInfo
                { ...
                , hsSourceDirs = ["test"]
                , otherModules = [ModuleName ["StaticTests","Generics"]]
                , defaultLanguage = Just Haskell2010
                , options = [(GHC,["-Wall"])]
                , targetBuildDepends =
                    [ Dependency (PackageName "base") AnyVersion
                    , Dependency (PackageName "spiros") AnyVersion
                    ]
                }
          }
    , condTreeConstraints =
        [ Dependency (PackageName "base") AnyVersion
        , Dependency (PackageName "spiros") AnyVersion
        ]
    , condTreeComponents = []
    }





-- the `unit` test-suite, `u`

> extractCondition (view buildable) u
Var (Flag (FlagName "examples"))

> extractCondition (not . view buildable) u
Lit False


-- the `doctest` test-suite, `d`

> extractCondition (view buildable) d
CNot (CAnd (CNot (Var (Impl GHCJS AnyVersion))) (CNot (Var (Flag (FlagName "test-doctest")))))

> extractCondition (not . view buildable) d
Lit False






> d & 




-- d & simplifyCondTree (\v -> v ^? (_Impl . _1) == Just GHCJS)

d & simplifyCondTree (\v -> v ^? (_Impl . _1) == Just GHCJS)


> d & simplifyCondTree (\case; Impl compiler _version -> Right (compiler == GHCJS); v -> Left v)

( [ Dependency (PackageName "base") AnyVersion,Dependency (PackageName "spiros") AnyVersion,Dependency (PackageName "doctest") AnyVersion
  ]
, TestSuite
  {testName = UnqualComponentName "", testInterface = TestSuiteExeV10 (mkVersion [1,0]) "DocTests.hs", testBuildInfo = BuildInfo {buildable = True, buildTools = [], buildToolDepends = [], cppOptions = [], asmOptions = [], cmmOptions = [], ccOptions = [], cxxOptions = [], ldOptions = [], pkgconfigDepends = [], frameworks = [], extraFrameworkDirs = [], asmSources = [], cmmSources = [], cSources = [], cxxSources = [], jsSources = [], hsSourceDirs = ["test"], otherModules = [], virtualModules = [], autogenModules = [], defaultLanguage = Just Haskell2010, otherLanguages = [], defaultExtensions = [], otherExtensions = [], oldExtensions = [], extraLibs = [], extraGHCiLibs = [], extraBundledLibs = [], extraLibFlavours = [], extraLibDirs = [], includeDirs = [], includes = [], installIncludes = [], options = [(GHC,["-Wall"])], profOptions = [], sharedOptions = [], staticOptions = [], customFieldsBI = [], targetBuildDepends = [Dependency (PackageName "base") AnyVersion,Dependency (PackageName "spiros") AnyVersion,Dependency (PackageName "doctest") AnyVersion], mixins = []}
  }
)

aka:

( [ ... ]

, TestSuite
  { testName      = UnqualComponentName "???"
  , testInterface = TestSuiteExeV10 (mkVersion [1,0]) "DocTests.hs"
  , testBuildInfo =
      BuildInfo
        { ...
        , hsSourceDirs = ["test"]
        , otherModules = [ModuleName ["StaticTests","Generics"]]
        , defaultLanguage = Just Haskell2010
        , options = [(GHC,["-Wall"])]
        , targetBuildDepends =
            [ Dependency (PackageName "base") AnyVersion
            , Dependency (PackageName "spiros") AnyVersion
            , Dependency (PackageName "doctest") AnyVersion
            ]
        }
  }
)



> d & simplifyCondTree (\case; Impl compiler _version -> Right (compiler == GHCJS); v -> Left v)





-}

----------------------------------------
{-NOTES


Distribution.Types.<TYPE>
Distribution.Types.<TYPE>.Lens



-- | A 'CondTree' is used to represent the conditional structure of
-- a Cabal file, reflecting a syntax element subject to constraints,
-- and then any number of sub-elements which may be enabled subject
-- to some condition.  Both @a@ and @c@ are usually 'Monoid's.
--
-- To be more concrete, consider the following fragment of a @Cabal@
-- file:
--
-- @
-- build-depends: base >= 4.0
-- if flag(extra)
--     build-depends: base >= 4.2
-- @
--
-- One way to represent this is to have @'CondTree' 'ConfVar'
-- ['Dependency'] 'BuildInfo'@.  Here, 'condTreeData' represents
-- the actual fields which are not behind any conditional, while
-- 'condTreeComponents' recursively records any further fields
-- which are behind a conditional.  'condTreeConstraints' records
-- the constraints (in this case, @base >= 4.0@) which would
-- be applied if you use this syntax
--
data CondTree v c a = CondNode
    { condTreeData        :: a
    , condTreeConstraints :: c
    , condTreeComponents  :: [CondBranch v c a]
    }




instance HasBuildInfo Component

instance HasBuildInfo Library

instance HasBuildInfo ForeignLib

instance HasBuildInfo Executable

instance HasBuildInfo Benchmark
instance HasBuildInfo BenchmarkStanza

instance HasBuildInfo TestSuite
instance HasBuildInfo TestSuiteStanza

instance HasBuildInfo BuildInfo







emptyBuildInfo :: BuildInfo
instance Monoid BuildInfo where
  mempty = BuildInfo {
    buildable           = True,
    buildTools          = [],
    buildToolDepends    = [],
    cppOptions          = [],
    asmOptions          = [],
    cmmOptions          = [],
    ccOptions           = [],
    cxxOptions          = [],
    ldOptions           = [],
    pkgconfigDepends    = [],
    frameworks          = [],
    extraFrameworkDirs  = [],
    asmSources          = [],
    cmmSources          = [],
    cSources            = [],
    cxxSources          = [],
    jsSources           = [],
    hsSourceDirs        = [],
    otherModules        = [],
    virtualModules      = [],
    autogenModules      = [],
    defaultLanguage     = Nothing,
    otherLanguages      = [],
    defaultExtensions   = [],
    otherExtensions     = [],
    oldExtensions       = [],
    extraLibs           = [],
    extraGHCiLibs       = [],
    extraBundledLibs    = [],
    extraLibFlavours    = [],
    extraLibDirs        = [],
    includeDirs         = [],
    includes            = [],
    installIncludes     = [],
    options             = [],
    profOptions         = [],
    sharedOptions       = [],
    staticOptions       = [],
    customFieldsBI      = [],
    targetBuildDepends  = [],
    mixins    = []
  }




-}
----------------------------------------
