> module Cata where

> import qualified Prelude
> import Prelude (Either (..), Maybe (..), Enum (..), (>), maybe)
> import Prelude.Unicode
> import Numeric.Natural (Natural)
> import Data.Function
> import GHC.Types (Matchability (..))
> import qualified GHC.Exts as Base (IsList (..))

How about some generalization?

> type Y ∷ (* → @anyMatchability *) → *
> data Y f = Y {y ∷ f (Y f)}

We need some more powerful catamorphoses to pierce through many levels of functors.

> cata ∷ ((Y f → α) → f (Y f) → f α) → (f α → α) → Y f → α
> cata fmap = fix \ κ f → f ∘ fmap (κ f) ∘ y
>
> ana ∷ ((α → Y f) → f α → f (Y f)) → (α → f α) → α → Y f
> ana fmap = fix \ α f → Y ∘ fmap (α f) ∘ f

A simple example — unary numbers.

> type ℕ = Y Maybe

Here is a witness of the isomorphose.

> fromNatural ∷ Natural → ℕ
> fromNatural = ana Prelude.fmap \ x → if x > 0 then Just (pred x) else Nothing
>
> toNatural ∷ ℕ → Natural
> toNatural = cata Prelude.fmap $ maybe 0 succ
>
> instance Enum ℕ where
>   toEnum = fromNatural ∘ toEnum
>   fromEnum = fromEnum ∘ toNatural

A harder example — lists.

> type Δ₁ = ( )
> type Σ = Either
> type Π = (, )
> type (∘) ∷ (* → @m *) → (* → @n *) →(* → @Unmatchable *)
> type family (∘) f g α where
>   (f ∘ g) α = f (g α)
> type List α = Y (Σ Δ₁ ∘ Π α)

Here is a witness of the isomorphose.

> toList ∷ List α → [α]
> toList (Y (Left ( ))) = [ ]
> toList (Y (Right (x, xs))) = x: toList xs
>
> fromList ∷ [α] → List α
> fromList [ ] = Y (Left ( ))
> fromList (x: xs) = Y (Right (x, fromList xs))

We should be able to get the same via a catamorphose, but it does not type check.

< toList' ∷ forall α. List α → [α]
< toList' = cata (Prelude.fmap ∘ Prelude.fmap) f
<   where
<     f ∷ (Σ Δ₁ ∘ Π [α]) [α] → [α]
<     f x = f x

Also, this instance does not pass.

< instance ((Σ Δ₁ ∘ Π α) ~ f α) ⇒ Base.IsList (Y (f α)) where
<   type Item (Y (f α)) = α
<   toList = toList
<   fromList = fromList

This one gives errors too.

< foldrViaCata ∷ (α → β → β) → β → List α → β
< foldrViaCata f z = cata (Prelude.fmap ∘ Prelude.fmap) f
<   where
<     f = \ x → case x of
<       Left ( ) → z
<       Right (x, y) → x `f` y
