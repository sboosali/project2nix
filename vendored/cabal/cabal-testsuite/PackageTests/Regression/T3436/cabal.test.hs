import Test.Cabal.Prelude
main = cabalTest $ do
    -- NB: This test doesn't really test #3436, because Cabal-1.2
    -- isn't in the system database and thus we can't see if the
    -- depsolver incorrectly chooses it.  Worth fixing if we figure
    -- out how to simulate the "global" database without root.
    r <- fails $ cabal' "new-build" ["custom-setup"]
    assertOutputContains "This is Cabal-2.0" r
