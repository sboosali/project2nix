module Distribution.Nixpkgs.Haskell.Cabal.Condition where
----------------------------------------
import  Prelude_project2nix

----------------------------------------
import Distribution.Nixpkgs.Haskell.Cabal.Condition.Types

----------------------------------------
import qualified "Cabal" Distribution.Types.CondTree                  as Cabal
import qualified "Cabal" Distribution.Types.Condition                 as Cabal

----------------------------------------

----------------------------------------

----------------------------------------

-- | (from @dhall-to-cabal@)

unifyCondTree
  :: ( Monoid a, Monoid x )
  => Cabal.CondTree v x a
  -> CondIfTree ( Cabal.Condition v ) a
unifyCondTree =
  let
    go acc condTree =
      case Cabal.condTreeComponents condTree of
        [] ->
          Val ( acc <> Cabal.condTreeData condTree )

        [c] ->
          If
            ( Cabal.condBranchCondition c )
            ( go
                ( acc <> Cabal.condTreeData condTree )
                ( Cabal.condBranchIfTrue c )
            )
            ( go
                ( acc <> Cabal.condTreeData condTree )
                ( case Cabal.condBranchIfFalse c of
                    Nothing ->
                      Cabal.CondNode mempty mempty mempty

                    Just c' ->
                      c'
                )
            )

        (c:cs) ->
          go acc ( condTree { Cabal.condTreeComponents = pushDownBranch c <$> cs } )

    pushDownBranch a b =
      b
        { Cabal.condBranchIfTrue =
            pushDownTree a ( Cabal.condBranchIfTrue b )
        , Cabal.condBranchIfFalse =
            case Cabal.condBranchIfFalse b of
              Nothing ->
                Just ( Cabal.CondNode mempty mempty [a] )

              Just tree ->
                Just ( pushDownTree a tree )
        }

    pushDownTree a b =
      b { Cabal.condTreeComponents = a : Cabal.condTreeComponents b }

  in
  go mempty

----------------------------------------
