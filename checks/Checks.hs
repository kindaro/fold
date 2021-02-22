{-# language NoImplicitPrelude #-}

module Main where

import Data.Function
import Test.Tasty
import Test.Tasty.QuickCheck
import qualified Fold
import qualified Prelude
import Prelude.Unicode
import Prelude (IO, Eq, Bool, Int)

main ∷ IO ( ) = defaultMain checks

isExtensionallyEqual ∷ Eq β ⇒ (α → β) → (α → β) → α → Bool
isExtensionallyEqual f g x = f x ≡ g x

(↔) ∷ Eq β ⇒ (α → β) → (α → β) → α → Bool
(↔) = isExtensionallyEqual

checks = testGroup ""
  [ testProperty "Identity out of the right fold" $ Fold.id ↔  Prelude.id @[Int]
  , testProperty "Map out of the right fold" \ (Fn f) → Fold.map f ↔  Prelude.map (f ∷ ℤ → ℤ)
  , testProperty "Left fold via `fix`" \ (Fn2 (f ∷ [ℤ] → ℤ → [ℤ])) z → Fold.foldlViaFix f z ↔ Prelude.foldl f z
  , testProperty "Left fold via the right" \ (Fn2 (f ∷ [ℤ] → ℤ → [ℤ])) z → Fold.foldlViaFoldr f z ↔ Prelude.foldl f z
  ]
