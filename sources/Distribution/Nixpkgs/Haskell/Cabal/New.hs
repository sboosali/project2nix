-- {-# LANGUAGE  #-}
-- {-# LANGUAGE OverloadedStrings #-}
-- {-# LANGUAGE OverloadedLists #-}

{-| 

@

>> 

@

-}
module Distribution.Nixpkgs.Haskell.Cabal.New
 ( module Distribution.Nixpkgs.Haskell.Cabal.New
 --, module Distribution.Nixpkgs.Haskell.Cabal.New.Types
 ) where
----------------------------------------
import Prelude.Distribution.Nixpkgs.Haskell.Cabal

--import Distribution.Nixpkgs.Haskell.Cabal.New.Types
----------------------------------------

-- import           "cabal2nix"  Distribution.Nixpkgs.Fetch
-- import           "cabal2nix"  Distribution.Nixpkgs.Hashes
-- import qualified "hackage-db" Distribution.Nixpkgs.Haskell.Hackage  as DB

--import qualified "bytestring" Data.ByteString.Char8                 as BS
import           "bytestring" Data.ByteString       (ByteString)
--import           "text"       Data.Text             (Text)
--import qualified "text"       Data.Text                             as T
--import qualified "text"       Data.Text.Encoding                    as T

-- import qualified "Cabal" Distribution.Package                       as Cabal
-- import           "Cabal" Distribution.PackageDescription
import qualified "Cabal" Distribution.PackageDescription            as Cabal
import qualified "Cabal" Distribution.PackageDescription.Parsec     as Cabal
import qualified "Cabal" Distribution.Parsec.Common                 as Cabal (showPError)
-- import           "Cabal" Distribution.Text          ( simpleParse, display )
-- import           "Cabal" Distribution.Version

-- import           "directory" System.Directory            ( doesDirectoryExist, doesFileExist, createDirectoryIfMissing, getHomeDirectory, getDirectoryContents )
-- import           "filepath" System.FilePath             ( (</>), (<.>) )

-- import           "base" System.Exit                 ( exitFailure )
-- import           "base" System.IO

----------------------------------------

{-|

e.g.

@

:set -XOverloadedStrings
import qualified Data.ByteString as B
s <- B.readFile "project2nix.cabal"
runParseGenericPackageDescription "project2nix.cabal" s

@

-}
runParseGenericPackageDescription
  :: FilePath
  -> ByteString
  -> Either String Cabal.GenericPackageDescription
runParseGenericPackageDescription fpath
  = first (unlines . fmap (Cabal.showPError fpath) . snd)
  . snd . Cabal.runParseResult
  . Cabal.parseGenericPackageDescription

----------------------------------------

{-NOTES

readGenericPackageDescription :: Verbosity -> FilePath -> IO GenericPackageDescription


readFile :: FilePath -> IO ByteString

-}
