module Main where

import Data.Function
import Test.Tasty
import Test.Tasty.QuickCheck
import qualified Prelude
import Prelude.Unicode
import Prelude (IO, Eq, Bool)
import Numeric.Natural

import qualified Fold
import qualified Cata

main ∷ IO ( )
main = defaultMain checks

checks ∷ TestTree
checks = testGroup ""
  [ testProperty "Identity out of the right fold" $ Fold.id ↔  Prelude.id @[ℤ]
  , testProperty "Map out of the right fold" \ (Fn (f ∷ ℤ → ℤ)) → Fold.map f ↔  Prelude.map f
  , testProperty "Sum out of the right fold" $ Fold.sum @ℤ ↔  Prelude.sum
  , testProperty "Left fold via `fix`" \ (Fn2 (f ∷ [ℤ] → ℤ → [ℤ])) z → Fold.foldlViaFix f z ↔ Prelude.foldl f z
  , testProperty "Left fold via the right" \ (Fn2 (f ∷ [ℤ] → ℤ → [ℤ])) z → Fold.foldlViaFoldr f z ↔ Prelude.foldl f z
  , testProperty "Natural is a fixed point" $ Cata.toNatural ∘ Cata.fromNatural ↔ Prelude.id
  , testProperty "List is a fixed point" $ Cata.toList ∘ Cata.fromList ↔ Fold.id @[ℤ]
  ]

isExtensionallyEqual ∷ Eq β ⇒ (α → β) → (α → β) → α → Bool
isExtensionallyEqual f g x = f x ≡ g x

infix 4 ↔
(↔) ∷ Eq β ⇒ (α → β) → (α → β) → α → Bool
(↔) = isExtensionallyEqual

instance Arbitrary Natural where
  arbitrary = arbitrarySizedNatural
  shrink    = shrinkIntegral

instance CoArbitrary Natural where
  coarbitrary = coarbitraryIntegral

instance Function Natural where
  function = functionIntegral
