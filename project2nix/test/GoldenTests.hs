{-# OPTIONS_GHC -fno-warn-missing-signatures #-}

{-# LANGUAGE PackageImports #-}
{-# LANGUAGE OverloadedStrings #-}

module GoldenTests where
----------------------------------------

import "tasty"        Test.Tasty
import "tasty-golden" Test.Tasty.Golden

import qualified "bytestring" Data.ByteString.Lazy as B
import           "bytestring" Data.ByteString.Lazy (ByteString)

----------------------------------------

main = defaultMain
 golden_stub

----------------------------------------

golden_stub :: TestTree
golden_stub = goldenVsString goldenName goldenFile goldenAction
 where
 goldenName   = "golden test (stub)"
 goldenFile   = "test/golden/project2nix.golden" 
 goldenAction = do
     return "project2nix"

----------------------------------------

{-NOTES

goldenVsString "golden test (stub)" "test/golden/project2nix.golden" (return "project2nix")


goldenVsString 

:: TestName	
test name

-> FilePath	
path to the «golden» file (the file that contains correct output)

-> IO ByteString	
action that returns a string

-> TestTree	
the test verifies that the returned string is the same as the golden file contents

Compare a given string against the golden file contents


Note about filenames. They are looked up in the usual way, thus relative names are relative to the processes current working directory. It is common to run tests from the package's root directory (via cabal test or cabal install --enable-tests), so if your test files are under the tests/ subdirectory, your relative file names should start with tests/ (even if your test.hs is itself under tests/, too).




Note about line endings. The best way to avoid headaches with line endings (when running tests both on UNIX and Windows) is to treat your golden files as binary, even when they are actually textual.

This means:

When writing output files from Haskell code, open them in binary mode (see openBinaryFile, withBinaryFile and hSetBinaryMode). This will disable automatic \n -> \r\n conversion on Windows. For convenience, this module exports writeBinaryFile which is just like writeFile but opens the file in binary mode. When using ByteStrings note that Data.ByteString and Data.ByteString.Lazy use binary mode for writeFile, while Data.ByteString.Char8 and Data.ByteString.Lazy.Char8 use text mode.
Tell your VCS not to do any newline conversion for golden files. For git check in a .gitattributes file with the following contents (assuming your golden files have .golden extension):
*.golden	-text
On its side, tasty-golden reads and writes files in binary mode, too.

Why not let Haskell/git do automatic conversion on Windows? Well, for instance, tar will not do the conversion for you when unpacking a release tarball, so when you run cabal install your-package --enable-tests, the tests will be broken.

-}
