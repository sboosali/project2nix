module Distribution.Nixpkgs.Haskell.Cabal.Condition.Types where

----------------------------------------
import  Prelude_project2nix

----------------------------------------
--import qualified "Cabal" Distribution.Types.BuildInfo                 as Cabal
import qualified "Cabal" Distribution.Types.CondTree                  as Cabal
--import qualified "Cabal" Distribution.Types.Condition                 as Cabal
import qualified "Cabal" Distribution.Types.Dependency                as Cabal
import qualified "Cabal" Distribution.Types.GenericPackageDescription as Cabal
--import qualified "Cabal" Distribution.Types.PackageDescription        as Cabal

----------------------------------------

import "base" Data.Tree

----------------------------------------

type CabalConditional a = Cabal.CondTree Cabal.ConfVar [Cabal.Dependency] a

----------------------------------------

data CondIfTree v a
  = Val a
  | If v ( CondIfTree v a ) ( CondIfTree v a )
  deriving (Show,Eq)

----------------------------------------

-- newtype Conditional a = Fix (ConditionalF a)

{-|

Parameters:

* @e@: boolean expressions
* @a@: the output

Useful Specializations:

@
Conditional 'Cabal.ConfVar' ['Cabal.Dependency']
@


@Conditional e a@ is isomorphic to:

@
'Fix' ('ConditionalF' e a)
@

@Conditional e a@ is isomorphic to:

@
'Free' (Branch e) a

where
data Branch e r = (e, r :*: r) ??
@


-}
data Conditional e a 
 = Unconditionally a
 | Conditionally   e (Conditional e a) (Conditional e a)
 deriving (Functor, Foldable, Traversable)

type instance Base (Conditional a) = ConditionalF a

-- | @'project' = 'projectConditional'@
instance Recursive (Conditional e a) where
  project = projectConditional

-- | @'embed' = 'embedConditionalF'@
instance Corecursive (Conditional e a) where
  embed = embedConditionalF 


----------------------------------------

data ConditionalF e a r
 = UnconditionallyF a
 | ConditionallyF   e r r
 deriving (Functor, Foldable, Traversable)
 
 -- Conditionally (Tree Condition) ??

----------------------------------------

data Branch e a = Branch
 { _condition :: e
 , _true      :: Conditional e a
 , _false     :: Conditional e a
 }

----------------------------------------

data BranchF e r = BranchF
 { _conditionF :: e
 , _trueF      :: r
 , _falseF     :: r
 }

----------------------------------------

projectConditional
  :: Conditional e a
  -> ConditionalF e a (Conditional e a)
projectConditional = \case
  Unconditionally a     -> UnconditionallyF a
  Conditionally   e x y -> ConditionallyF   e x y

embedConditionalF
  :: ConditionalF e a (Conditional e a)
  -> Conditional e a
embedConditionalF = \case
  UnconditionallyF a     -> Unconditionally a
  ConditionallyF   e x y -> Conditionally   e x y

----------------------------------------

-- (v -> Bool) -> Condition v a -> Condition Bool a

----------------------------------------

data TreeF a r = NodeF
 { _rootLabelF :: a
 , _subForestF :: [r]
 }

-- type ForestF a r = [r]

type instance Base (Tree a) = TreeF a

-- | @'project' = 'projectTree'@
instance Recursive (Tree a) where
  project = projectTree

-- | @'embed' = 'embedTreeF'@
instance Corecursive (Tree a) where
  embed = embedTreeF

----------------------------------------

projectTree
  :: Tree a
  -> TreeF a (Tree a)
projectTree Node{..} = NodeF
 { _rootLabelF = rootLabel 
 , _subForestF = subForest 
 }

embedTreeF
  :: TreeF a (Tree a)
  -> Tree a
embedTreeF NodeF{..} = Node
 { rootLabel = _rootLabelF
 , subForest = _subForestF
 }

----------------------------------------
