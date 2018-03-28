{-# LANGUAGE CPP #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses #-}
----------------------------------------

{-|


-}
module Distribution.Nixpkgs.Haskell.Derivation.Types where
----------------------------------------
import  Prelude_project2nix
----------------------------------------

--import Distribution.Nixpkgs.Haskell.Cabal.Condition.Types

----------------------------------------

import Control.DeepSeq
import Control.Lens
import Data.List
import Data.Set ( Set )
import qualified Data.Set as Set
import Data.Set.Lens
import Distribution.Package
import Distribution.PackageDescription ( FlagAssignment, unFlagName, unFlagAssignment )
import GHC.Generics ( Generic )

----------------------------------------

-- | (from @cabal2nix@). 
data Derivation = MkDerivation
  { _pkgid                      :: PackageIdentifier
  , _revision                   :: Int
  , _src                        :: DerivationSource
  , _subpath                    :: FilePath
  , _isLibrary                  :: Bool
  , _isExecutable               :: Bool
  , _extraFunctionArgs          :: Set Binding
  , _setupDepends               :: BuildInfo
  , _libraryDepends             :: BuildInfo
  , _executableDepends          :: BuildInfo
  , _testDepends                :: BuildInfo
  , _benchmarkDepends           :: BuildInfo
  , _configureFlags             :: Set String
  , _cabalFlags                 :: FlagAssignment
  , _runHaddock                 :: Bool
  , _jailbreak                  :: Bool
  , _doCheck                    :: Bool
  , _testTarget                 :: String
  , _hyperlinkSource            :: Bool
  , _enableLibraryProfiling     :: Bool
  , _enableExecutableProfiling  :: Bool
  , _enableSplitObjs            :: Bool
  , _phaseOverrides             :: String
  , _editedCabalFile            :: String
  , _enableSeparateDataOutput   :: Bool
  , _metaSection                :: Meta
  }
  deriving (Show, Eq, Generic)

emptyDerivation :: Derivation
emptyDerivation = _ -- MkDerivation

----------------------------------------

data Dependencies a = Dependencies
  { _haskell   :: a  -- ^ @build-depends@ 
  , _tool      :: a  -- ^ @tool-depends@ 
  , _pkgconfig :: a  -- ^ @pkgconfig-depends@ 
  , _system    :: a  -- ^ @extra-libraries@ 
  }

----------------------------------------

data Component
 = Library    -- ^ represents: the @library@ stanza, including any sub-libraries; and any @foreign-library@ stanzas. 
 | Executable -- ^ @executable@
 | TestSuite  -- ^ @test-suite@
 | Benchmark  -- ^ @benchmark@
 | Setup      -- ^ represents @custom-setup@
 
----------------------------------------
 
makeLenses ''Derivation
makeLenses ''Dependencies

makePrisms ''Component


----------------------------------------

{- $ Dependencies


From the <https://www.haskell.org/cabal/users-guide/developing-packages.html Cabal User Guide>:



* System dependencies:

@extra-libraries: token list@

A list of extra libraries to link with.


* Dependencies on Haskell executables:

@build-tool-depends: package:executable list@

A list of Haskell programs needed to build this component. Each is specified by the package containing the executable and the name of the executable itself, separated by a colon, and optionally followed by a version bound. It is fine for the package to be the current one, in which case this is termed an internal, rather than external executable dependency.

External dependencies can (and should) contain a version bound like conventional build-depends dependencies. Internal deps should not contain a version bound, as they will be always resolved within the same configuration of the package in the build plan. Specifically, version bounds that include the package’s version will be warned for being extraneous, and version bounds that exclude the package’s version will raise and error for being impossible to follow.

Cabal can make sure that specified programs are built and on the PATH before building the component in question. It will always do so for internal dependencies, and also do so for external dependencies when using Nix-style local builds.

build-tool-depends was added in Cabal 2.0, and it will be ignored (with a warning) with old versions of Cabal. See build-tools for more information about backwards compatibility.


* @pkgconfig@ dependencies:

@pkgconfig-depends: package list@

A list of pkg-config packages, needed to build this package. They can be annotated with versions, e.g. gtk+-2.0 >= 2.10, cairo >= 1.0. If no version constraint is specified, any version is assumed to be acceptable. Cabal uses pkg-config to find if the packages are available on the system and to find the extra compilation and linker options needed to use the packages.

If you need to bind to a C library that supports pkg-config (use pkg-config --list-all to find out if it is supported) then it is much preferable to use this field rather than hard code options into the other fields.


* OSX Framework dependencies:

@frameworks: token list@

On Darwin/MacOS X, a list of frameworks to link to. See Apple’s developer documentation for more details on frameworks. This entry is ignored on all other platforms.


-}

----------------------------------------

{- $ Components


From the <https://www.haskell.org/cabal/users-guide/developing-packages.html Cabal User Guide>:


* Foreign libraries:

Foreign libraries are system libraries intended to be linked against programs written in C or other “foreign” languages. They come in two primary flavours: dynamic libraries (@.so@ files on Linux, @.dylib@ files on OSX, @.dll@ files on Windows, etc.) are linked against executables when the executable is run (or even lazily during execution), while static libraries (@.a@ files on Linux and OSX, @.lib@ files on Windows) get linked against the executable at compile time.

Foreign libraries only work with GHC 7.8 and later.

A typical stanza for a foreign library looks like

@
foreign-library myforeignlib
  type:                native-shared
  lib-version-info:    6:3:2

  if os(Windows)
    options: standalone
    mod-def-file: MyForeignLib.def

  other-modules:       MyForeignLib.SomeModule
                       MyForeignLib.SomeOtherModule
  build-depends:       base >=4.7 && <4.9
  hs-source-dirs:      src
  c-sources:           csrc/MyForeignLibWrapper.c
  default-language:    Haskell2010
@




-}

----------------------------------------

{- NOTES 
-}

----------------------------------------
