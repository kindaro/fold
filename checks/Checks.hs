{-# language NoImplicitPrelude #-}

module Main where

import Data.Function
import Test.Tasty
import Test.Tasty.QuickCheck
import qualified Fold
import qualified Prelude
import Prelude.Unicode
import Prelude (IO, Eq, Bool)

main ∷ IO ( ) = defaultMain checks

isExtensionallyEqual ∷ Eq β ⇒ (α → β) → (α → β) → α → Bool
isExtensionallyEqual f g x = f x ≡ g x

(↔) ∷ Eq β ⇒ (α → β) → (α → β) → α → Bool
(↔) = isExtensionallyEqual

checks = testGroup ""
  [ testProperty "Identity out of the right fold" $ Fold.id ↔  Prelude.id @[ℤ]
  , testProperty "Map out of the right fold" \ (Fn (f ∷ ℤ → ℤ)) → Fold.map f ↔  Prelude.map f
  , testProperty "Sum out of the right fold" $ Fold.sum @ℤ ↔  Prelude.sum
  , testProperty "Left fold via `fix`" \ (Fn2 (f ∷ [ℤ] → ℤ → [ℤ])) z → Fold.foldlViaFix f z ↔ Prelude.foldl f z
  , testProperty "Left fold via the right" \ (Fn2 (f ∷ [ℤ] → ℤ → [ℤ])) z → Fold.foldlViaFoldr f z ↔ Prelude.foldl f z
  ]
